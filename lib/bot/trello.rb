require 'active_model'

module Bot
  class Trello
    include ActiveModel::Naming
    include ActiveSupport::Configurable
    include ActiveModel::AttributeMethods

    # Trello configuration
    config_accessor :username
    config_accessor :secret, :key, :public_key

    attr_accessor :member, :cards

    def initialize
      self.member = ::Trello::Member.find(self.config.username)
      self.cards  = self.member.cards.map{|card| Bot::TrackedCard.new(card, self)}
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
    def update
      self.cards.each do |tracked_card|
        # update tracking status
        puts " * Scanning Trello #{tracked_card.short_id}"
        tracked_card.update_tracking_status
        ticket_list = tracked_card.jira_tickets.join(', ')
        ticket_list = 'none' if ticket_list.blank?
        puts "   (#{ticket_list})"

        # run new commands
        tracked_card.new_commands.each do |command|
          puts " * processing new command on card #{tracked_card.short_id}: #{command.summary}"
          tracked_card.run(command)
        end

        # add any new comments
        tracked_card.jira_tickets.each do |ticket_id|
          if tracked_card.update_comments_from_jira(ticket_id)
            puts " * updating data from JIRA #{ticket_id}"
          end
        end

        # check resolutions
        tracked_card.jira_tickets.each do |ticket_id|
          if tracked_card.update_resolution_status(ticket_id)
            puts " #* JIRA #{ticket_id} marked as RESOLVED"
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
