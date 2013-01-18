require 'awesome_print'
require 'trello'
require 'time'
require 'yaml'
require 'optparse'
require 'rest_client'
require 'moneta'
require 'api_cache'

require 'active_support'
require 'active_model'
# require 'active_record'

require 'bot/command'
require 'bot/comment_scanner'
require 'bot/tracked_card'
require 'bot/trello'
require 'jira/attachment'
require 'jira/client'
require 'jira/comment'
require 'jira/ticket'

APICache.store = Moneta.new(:File, :dir=>'./tmp/cache/moneta')
APICache.logger = Logger.new('./log/apicache.log')

module TrelloJiraBridge
  def self.load_config(config_file='config/config.yml')
    #RestClient.enable Rack::CommonLogger, STDOUT


    @config = YAML.load_file(config_file)

    Jira::Client.config.site      = @config['jira']['site']
    Jira::Client.config.user      = @config['jira']['user']
    Jira::Client.config.password  = @config['jira']['password']

    Bot::Trello.config.username   = @config['trello']['user']
    Bot::Trello.config.secret     = @config['trello']['secret']
    Bot::Trello.config.app_key    = @config['trello']['app_key']
    Bot::Trello.config.public_key = @config['trello']['public_key']

    Bot::Trello.setup_oauth!

#    ActiveRecord::Base.logger = Logger.new('log/debug.log')
#    ActiveRecord::Base.configurations = YAML::load(IO.read('db/config.yml'))
#    ActiveRecord::Base.establish_connection('development')

    puts 'Configuration loaded.'
  end
end
