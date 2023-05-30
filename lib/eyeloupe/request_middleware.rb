module Eyeloupe

  class RequestMiddleware

    def initialize(app)
      @app = app
      @processor = Processors::InRequest.instance
    end

    def call(env)

      request = ActionDispatch::Request.new(env)

      if enabled?(request) && !skip_request?(request)
        @processor.start_timer

        begin
          status, headers, response = @app.call(env)
          [status, headers, response]
        rescue Exception => e
          exception = ActionDispatch::ExceptionWrapper.new(env, e)
          status = exception.status_code
          headers = {}
          response = e.message
          raise
        ensure
          @processor.init(request, env, status, headers, response).process
        end
      else
        @app.call(env)
      end

    end

    protected

    # Check if capture is enabled, if so we are looking to the capture cookie, if no cookie present capture is enabled by default
    def enabled?(request)
      if Eyeloupe.configuration.capture
        if request.cookies['eyeloupe_capture'].present?
          request.cookies['eyeloupe_capture'] == "true"
        else
          true
        end
      else
        false
      end
    end

    def skip_request?(request)
      excluded_paths = %w[mini-profiler eyeloupe active_storage] + Eyeloupe.configuration.excluded_paths

      excluded_paths.each do |item|
        return true if request.path =~ /#{item}/
      end

      false
    end

  end
end