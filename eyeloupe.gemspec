require_relative "lib/eyeloupe/version"

Gem::Specification.new do |spec|
  spec.name        = "eyeloupe"
  spec.version     = Eyeloupe::VERSION
  spec.authors     = ["Alex"]
  spec.email       = ["dev@alexandrelion.com"]
  spec.homepage    = "https://rubygems.org/gems/eyeloupe"
  spec.summary     = "Monitor your Rails app in one place"
  spec.description = "The All in one Rails monitoring tool"
    spec.license     = "MIT"
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "sprockets-rails"
  spec.add_dependency "rails", ">= 7"
  spec.add_dependency "tailwindcss-rails"
  spec.add_dependency "importmap-rails"
  spec.add_dependency "pagy"
end
