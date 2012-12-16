require 'active_model'

module Bot
  class Trello
    include ActiveModel::Naming
    include ActiveSupport::Configurable
    include ActiveModel::AttributeMethods

    # Trello configuration
    config_accessor :user
    config_accessor :secret, :key, :public_key

    attr_accessor :member, :cards

    def initialize
      self.member = ::Trello::Member.find(self.config.user)
      self.cards  = self.member.cards.map{|card| Bot::TrackedCard.new(card, self)}
    end

    def self.update_comments(trello_card, jira_ticket)
      puts jira_ticket.summary
      jira_ticket.comments.each do |comment|
        link = jira_ticket.comment_web_link(comment)
        text = [comment.header, comment.body, link].join("\n")
        trello_card.add_comment("#{jira_ticket.ticket_id}: #{text}")
      end
    end

    def username
      self.member.username
    end

    def user_id
      self.member.id
    end

    # The bot will look for commands and respond to them.
    # It responds to every command with a comment.
    # It will post comments and status updates as well.
    # New commands are found by looking for patterns like '@jirabot track ws-2345'
    # that have not yet been responded to.
    def scan_trello_cards
      self.cards.each do |tracked_card|
        tracked_card.new_commands.each do |comment|
          Bot::Command.scan(self.config.user, comment.data['text'])
          if text.match(command_regex)
            command = $1.downcase
            ticket_id = $2.upcase
            ticket = Jira::Ticket.get(ticket_id)
            update_comments(card, ticket)
          end
        end
      end
    end

    def self.setup_oauth!
      $auth = ::Trello::Authorization
      policy = $auth::OAuthPolicy
      $auth.send(:remove_const, :AuthPolicy) if ::Trello::Authorization.const_defined?(:AuthPolicy)
      $auth.const_set :AuthPolicy, policy

      consumer = $auth::OAuthCredential.new(self.config.public_key, self.config.secret)
      $auth::OAuthPolicy.consumer_credential = consumer

      oauth_credential = $auth::OAuthCredential.new(self.config.app_key, nil)
      $auth::OAuthPolicy.token = oauth_credential
      true
    end

  end
end
