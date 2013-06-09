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

require 'active_support'
require 'active_model'

require 'bot/command'
require 'bot/comment_scanner'
require 'bot/tracked_card'
require 'bot/trello'
require 'jira4/attachment'
require 'jira4/client'
require 'jira4/comment'
require 'jira4/ticket'

APICache.store = Moneta.new(:File, :dir=>'./tmp/cache/moneta')
APICache.logger = Logger.new('./log/apicache.log')
LOG = Logger.new('./log/bot.log')

module TrelloJiraBridge
  def self.load_config(config_file='config/config.yml')
    @config = YAML.load_file(config_file)

    Jira4::Client.config.site      = @config['jira']['site']
    Jira4::Client.config.user      = @config['jira']['user']
    Jira4::Client.config.password  = @config['jira']['password']

    Bot::Trello.config.username   = @config['trello']['user']
    Bot::Trello.config.secret     = @config['trello']['secret']
    Bot::Trello.config.app_key    = @config['trello']['app_key']
    Bot::Trello.config.public_key = @config['trello']['public_key']

    Bot::Trello.setup_oauth!

    LOG.debug 'Configuration loaded.'
  end
end
