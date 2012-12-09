# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "trello-jira-bot"
  s.version     = TrelloJira::VERSION
  s.authors     = ["Jeremy Seitz"]
  s.email       = ["jeremy@somebox.com"]
  s.homepage    = "https://github.com/local-ch/trello-jira-bridge"
  s.summary     = %q{Ruby library and command-line tool for integrating workflow between Trello and JIRA.}
  s.description = %q{}

  s.rubyforge_project = "trello-jira-bot"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:

  s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "ruby-trello"  
  
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-test"  
end
