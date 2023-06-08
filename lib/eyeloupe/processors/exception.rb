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

        file = backtrace ? backtrace[0].split(":")[0] : ""
        line = backtrace ? backtrace[0].split(":")[1].to_i : 0

        existing = Eyeloupe::Exception.where(kind: exception.class.name, file: file, line: line).first

        if existing
          existing.update(count: existing.count + 1)
          existing
        else
          Eyeloupe::Exception.create(
            hostname: ActionDispatch::Request.new(env).host,
            kind: exception.class.name,
            message: exception.message,
            full_message: exception.full_message,
            location: read_file(backtrace || []),
            file: file,
            line: line,
            stacktrace: backtrace || [],
            )
        end
      end

      protected

      def read_file(trace)
        file = trace[0].split(":")[0]
        line = trace[0].split(":")[1].to_i

        if File.exist?(file)
          lines = File.readlines(file)
          start = line - 5
          start = 0 if start < 0
          lines[start..line+5]
        else
          []
        end
      end
    end
  end
end
