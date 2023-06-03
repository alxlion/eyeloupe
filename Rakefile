require "bundler/setup"
require "rake/testtask"

APP_RAKEFILE = File.expand_path("test/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"

load "rails/tasks/statistics.rake"

require "bundler/gem_tasks"

task default: "test"
Rake::TestTask.new do |task|
  task.pattern = "test/*_test.rb"
end