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

    initializer "eyeloupe.importmap", :before => "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
      # https://github.com/rails/importmap-rails#sweeping-the-cache-in-development-and-test
      app.config.importmap.cache_sweepers << root.join("app/assets/javascripts")
    end
  end
end
