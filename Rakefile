require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'rake/clean'
#require 'standalone_migrations'

#StandaloneMigrations::Tasks.load_tasks
require 'bundler/gem_tasks'


# load 'tasks/*.rake'
Dir.glob('tasks/**/*.rake').each { |r| Rake.application.add_import r }


