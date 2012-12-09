require 'awesome_print'
require 'trello'
require 'time'
require 'yaml'
require 'optparse'
require 'rest_client'
require 'active_support'


require 'bot'
require 'jira/client'
require 'jira/comment'
require 'jira/ticket'


module TrelloJiraBridge
  def self.load_config(config_file)
    @config = YAML.load_file(config_file)
    p @config

    Jira::Client.config.url = @config['jira']['url']
    Jira::Client.config.user = @config['jira']['user']
    Jira::Client.config.password = @config['jira']['password']
  end
end
