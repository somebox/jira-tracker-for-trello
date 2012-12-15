
desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r trello_jira_bridge -r wirble -r irb_console"
end
