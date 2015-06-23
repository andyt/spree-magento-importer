require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'spree/testing_support/common_rake'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = 'spec/**/*_spec.rb'
end

RuboCop::RakeTask.new do |task|
  task.fail_on_error = true
  task.requires << 'rubocop-rspec'
end

task default: [:rubocop, :spec]

desc 'Generates a dummy app for testing'
task :test_app do
  ENV['LIB_NAME'] = 'spree/core'
  Rake::Task['common:test_app'].invoke
end
