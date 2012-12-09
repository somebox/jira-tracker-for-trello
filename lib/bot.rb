module Bot
  class Command
    attr_accessor :name
    attr_accessor :trello_card
    attr_accessor :jira_ticket

    def initialize(card)
      self.name = name
      self.trello_card = trello_card
      self.jira_ticket = jira_ticket
      self
    end

    def self.detect(body)
      case body
      when /track jira\:([\d\w-]+)/i
        'track'
      end
    end
  end
end
