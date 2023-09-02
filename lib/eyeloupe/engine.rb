require 'importmap-rails'

module Eyeloupe
  class Engine < ::Rails::Engine
    isolate_namespace Eyeloupe

    initializer "eyeloupe.assets" do |app|
      app.config.assets.precompile += %w[ eyeloupe_manifest ]
    end

    initializer 'eyeloupe.add_middleware' do |app|
      app.config.middleware.insert(0, Eyeloupe::RequestMiddleware)
    end

    initializer 'eyeloupe.active_job' do
      ActiveSupport.on_load(:active_job) do
        include Eyeloupe::Concerns::Rescuable

        ActiveSupport::Notifications.subscribe("enqueue_at.active_job") do |*args|
          Eyeloupe::Processors::Job.instance.process(ActiveSupport::Notifications::Event.new(*args))
        end

        ActiveSupport::Notifications.subscribe("enqueue.active_job") do |*args|
          Eyeloupe::Processors::Job.instance.process(ActiveSupport::Notifications::Event.new(*args))
        end

        ActiveSupport::Notifications.subscribe("perform_start.active_job") do |*args|
          Eyeloupe::Processors::Job.instance.run(ActiveSupport::Notifications::Event.new(*args))
        end

        ActiveSupport::Notifications.subscribe("perform.active_job") do |*args|
          Eyeloupe::Processors::Job.instance.complete(ActiveSupport::Notifications::Event.new(*args))
        end

        ActiveSupport::Notifications.subscribe("retry_stopped.active_job") do |*args|
          Eyeloupe::Processors::Job.instance.fail(ActiveSupport::Notifications::Event.new(*args))
        end

        ActiveSupport::Notifications.subscribe("discard.active_job") do |*args|
          Eyeloupe::Processors::Job.instance.disacard(ActiveSupport::Notifications::Event.new(*args))
        end
      end
    end

    initializer "eyeloupe.configure_openai" do
      OpenAI.configure do |config|
        config.access_token = Eyeloupe::configuration.openai_access_key
      end
    end

    initializer "eyeloupe.configure_sidekiq" do
      if defined?(Sidekiq)
        Sidekiq.configure_server do |config|
          config.error_handlers << proc {|ex,ctx_hash| Eyeloupe::Processors::Exception.instance.process(nil, ex) }
        end
      end
    end

    initializer 'eyeloupe.override_net_http_request' do
      require 'net/http'
      Net::HTTP.class_eval do
        alias original_request request
        def request(req, body = nil, &block)
          res, ex = nil
          exception_processor = Eyeloupe::Processors::Exception.instance
          out_request_processor = Eyeloupe::Processors::OutRequest.instance

          if Eyeloupe.configuration.capture
            begin
              out_request_processor.init(req, body)
              res = original_request(req, body, &block)
            rescue => e
              ex = exception_processor.process(nil, e)
            ensure
              out_request_processor.process(res, ex)
            end
          else
            res = original_request(req, body, &block)
          end
          res
        end
      end
    end

    initializer "eyeloupe.importmap", :before => "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
      # https://github.com/rails/importmap-rails#sweeping-the-cache-in-development-and-test
      app.config.importmap.cache_sweepers << root.join("app/assets/javascripts")
    end
  end
end
