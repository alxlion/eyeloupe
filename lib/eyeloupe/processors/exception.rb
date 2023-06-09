module Eyeloupe
  module Processors
    class Exception
      include Singleton

      # @param [Hash, nil] env Rack environment
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

        create_or_update_exception(env, exception.class.name || "", file, line, backtrace, exception.message, exception.full_message)
      end

      protected

      # @param [Array] trace The backtrace
      # @return [Array] The source code lines
      def read_file(trace)
        file = trace.size > 0 ? trace[0].split(":")[0] : ""
        line = trace.size > 0 ? trace[0].split(":")[1].to_i : 0

        if File.exist?(file)
          lines = File.readlines(file)
          start = line - 5
          start = 0 if start < 0
          lines[start..line+5] || []
        else
          []
        end
      end

      # @param [Hash, nil] env Rack environment
      # @param [String] kind The exception class name
      # @param [String] file The file path
      # @param [Integer] line The line number
      # @param [Array] backtrace The backtrace
      # @param [String] message The exception message
      # @param [String] full_message The full exception message
      # @return [Eyeloupe::Exception] The exception model
      def create_or_update_exception(env, kind, file, line, backtrace, message, full_message)
        obj = Eyeloupe::Exception.find_by(kind: kind, file: file, line: line)

        if obj
          obj.update(count: obj.count + 1)
        else
          obj = Eyeloupe::Exception.create(
            hostname: ActionDispatch::Request.new(env).host,
            kind: kind,
            message: message,
            full_message: full_message,
            location: read_file(backtrace || []).to_json,
            file: file,
            line: line,
            stacktrace: (backtrace || []).to_json,
            )
        end

        obj
      end
    end
  end
end
