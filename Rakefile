require 'rubygems'
require 'bundler'
require "bundler/gem_tasks"
require 'rake/testtask'
require 'rake/clean'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'bundler/gem_tasks'

# load 'tasks/*.rake'
Dir.glob('tasks/**/*.rake').each { |r| Rake.application.add_import r }


