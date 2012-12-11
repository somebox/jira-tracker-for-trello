class Trello
  include ActiveSupport::Configurable

  # Trello configuration
  config_accessor :user
  config_accessor :secret, :key, :public_key

  attr_accessor :member

  def initialize
    self.member = Trello::Member.find(self.config.user)
  end

  def tracked_cards
    self.member.cards.map{|card| Bot::TrackedCard.new(card, self.member)}
  end

  def self.update_comments(trello_card, jira_ticket)
    puts jira_ticket.summary
    jira_ticket.comments.each do |comment|
      text = [comment.header, comment.body, comment.web_link].join("\n")
      trello_card.add_comment("#{jira_ticket.ticket_id}: #{text}")
    end
  end

  # The bot will look for commands and respond to them.
  # It responds to every command with a comment.
  # It will post comments and status updates as well.
  # New commands are found by looking for patterns like '@jirabot track ws-2345'
  # that have not yet been responded to.
  def scan_trello_cards
    self.tracked_cards.each do |tracked_card|
      # comments are Trello::Action instances, ordered newest to oldest
      to_scan = tracked_card ? comments.select{|c| c.date > last_response.date} : comments
      to_scan.each do |comment|
        text = comment.data['text']
        command_regex = /\@#{self.member.username}\/i)\s+(track|untrack)\s+([\d\w-]+)/i
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
    policy = Trello::Authorization::OAuthPolicy
    Trello::Authorization.const_set :AuthPolicy, policy

    consumer = Trello::Authorization::OAuthCredential.new(self.config.public_key, self.config.secret)
    Trello::Authorization::OAuthPolicy.consumer_credential = consumer

    oauth_credential = Trello::Authorization::OAuthCredential.new(self.config.app_key, nil)
    Trello::Authorization::OAuthPolicy.token = oauth_credential
    true
  end

end
