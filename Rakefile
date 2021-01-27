# frozen_string_literal: true

begin
  require "gemsmith/rake/setup"
  require "bundler/audit/task"
  require "rspec/core/rake_task"

  Bundler::Audit::Task.new
  RSpec::Core::RakeTask.new :spec
rescue LoadError => error
  puts error.message
end