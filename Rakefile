require 'rubygems'
require 'bundler'
require "bundler/gem_tasks"

require 'rspec/core/rake_task'
require 'rake/clean'
#require 'standalone_migrations'

#StandaloneMigrations::Tasks.load_tasks


# load 'tasks/*.rake'
Dir.glob('tasks/**/*.rake').each { |r| Rake.application.add_import r }

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
