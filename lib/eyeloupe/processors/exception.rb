module Eyeloupe
  module Processors
    class Exception
      include Singleton

      # @param [Hash] env Rack environment
      # @param [Exception] exception The exception object
      # @return [Eyeloupe::Exception] The exception model
      def process(env, exception)
        if env['action_dispatch.backtrace_cleaner']
          backtrace = env['action_dispatch.backtrace_cleaner'].filter(exception.backtrace)
          backtrace = exception.backtrace if backtrace.blank?
        else
          backtrace = exception.backtrace
        end

        existing = Eyeloupe::Exception.where(kind: exception.class.name, message: exception.message).first

        if existing
          existing.update(count: existing.count + 1)
          ex = existing
        else
          ex = Eyeloupe::Exception.create(
            hostname: ActionDispatch::Request.new(env).host,
            kind: exception.class.name,
            message: exception.message,
            full_message: exception.full_message,
            stacktrace: backtrace || [],
            )
        end

        ex
      end
    end
  end
end
