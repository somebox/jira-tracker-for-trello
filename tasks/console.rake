
desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -Ilib -rtrello_jira_bridge"
end
