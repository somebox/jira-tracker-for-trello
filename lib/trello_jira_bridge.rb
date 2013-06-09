Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'awesome_print'
require 'trello'
require 'time'
require 'yaml'
require 'optparse'
require 'rest_client'
require 'moneta'
require 'api_cache'

require 'active_support/all'
require 'active_model'

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
LOG = Logger.new('./log/bot.log')

module TrelloJiraBridge
  def self.load_config(config_file='config/config.yml')
    @config = YAML.load_file(config_file)

    Jira::Client.config.site      = @config['jira']['site']
    Jira::Client.config.user      = @config['jira']['user']
    Jira::Client.config.password  = @config['jira']['password']
    Jira::Client.config.cache_time = @config['cache']['time']
    Jira::Client.config.cache_valid = @config['cache']['valid']
    Jira::Ticket.config.jira_version = @config['jira']['version'].to_i

    Bot::Trello.config.username   = @config['trello']['user']
    Bot::Trello.config.secret     = @config['trello']['secret']
    Bot::Trello.config.app_key    = @config['trello']['app_key']
    Bot::Trello.config.public_key = @config['trello']['public_key']
    Bot::Trello.config.cache_time = @config['cache']['time']
    Bot::Trello.config.cache_valid = @config['cache']['valid']

    Bot::Trello.setup_oauth!

    LOG.debug 'Configuration loaded.'
  end
end
