module Eyeloupe

  class RequestMiddleware

    # @return [Eyeloupe::Processors::InRequest]
    attr_accessor :inrequest_processor

    # @return [Eyeloupe::Processors::Exception]
    attr_accessor :exception_processor

    def initialize(app)
      @app = app
      @inrequest_processor = Processors::InRequest.instance
      @exception_processor = Processors::Exception.instance
    end

    # @param [Hash] env Rack environment
    def call(env)

      request = ActionDispatch::Request.new(env)
      ex = nil

      if enabled?(request) && !skip_request?(request)
        @inrequest_processor.start_timer

        begin
          status, headers, response = @app.call(env)

          framework_exception = env['action_dispatch.exception']
          if framework_exception
            ex = @exception_processor.process(env, framework_exception)
          end

          [status, headers, response]
        rescue Exception => e
          exception = ActionDispatch::ExceptionWrapper.new(env, e)
          status = exception.status_code
          headers = {}
          response = e.message
          ex = @exception_processor.process(env, e)
          raise
        ensure
          @inrequest_processor.init(request, env, status, headers, response, ex).process
        end
      else
        @app.call(env)
      end

    end

    protected

    # Check if capture is enabled, if so we are looking to the capture cookie, if no cookie present capture is enabled by default
    #
    # @param [ActionDispatch::Request] request
    # @return [Boolean]
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

    # Check if the request path is in the excluded paths
    #
    # @param [ActionDispatch::Request] request
    # @return [Boolean]
    def skip_request?(request)
      excluded_paths = %w[mini-profiler eyeloupe active_storage] + Eyeloupe.configuration.excluded_paths

      excluded_paths.each do |item|
        return true if request.path =~ /#{item}/
      end

      false
    end

  end
end