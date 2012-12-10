class Bot
  include ActiveSupport::Configurable

  # Trello configuration
  config_accessor :user
  config_accessor :secret, :key, :public_key

  def self.update_comments(trello_card, jira_ticket)
    puts jira_ticket.summary
    jira_ticket.comments.each do |comment|
      text = [comment.header, comment.body, comment.web_link].join("\n")
      trello_card.add_comment("#{jira_ticket.ticket_id}: #{text}")
    end
  end

  def self.scan_trello_cards
    member = Trello::Member.find(self.config.user)
    cards = member.cards
    cards.each do |card|
      card.actions(:filter=>'commentCard').each do |action|
        text = action.data['text']
        if text.match(/(track|import|untrack) JIRA\:([\d\w-]+)/i)
          command = $1.downcase
          ticket = Jira::Ticket.get($2)
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
  end

end
