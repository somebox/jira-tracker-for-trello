require 'awesome_print'
require 'trello'
require 'time'
require 'yaml'
require 'optparse'
require 'rest_client'
require 'active_support'
require 'active_record'

require 'bot'
require 'jira/client'
require 'jira/comment'
require 'jira/ticket'


module TrelloJiraBridge
  def self.load_config(config_file)
    @config = YAML.load_file(config_file)
    
    Jira::Client.config.site = @config['jira']['site']
    Jira::Client.config.user = @config['jira']['user']
    Jira::Client.config.password = @config['jira']['password']

    Bot.config.user = @config['trello']['user']
    Bot.config.secret  = @config['trello']['secret']
    Bot.config.app_key  = @config['trello']['app_key']
    Bot.config.public_key  = @config['trello']['public_key']

    Bot.setup_oauth!

    ActiveRecord::Base.logger = Logger.new('log/debug.log')
    ActiveRecord::Base.configurations = YAML::load(IO.read('config/database.yml'))
    ActiveRecord::Base.establish_connection('development')

  end
end
