module Bot
  class Command
    attr_accessor :name, :ticket_id

    SUPPORTED_COMMANDS = %w(track untrack import) # TODO: add close, comment

    def initialize(name, ticket_id)
      self.name = name
      self.ticket_id = ticket_id
    end

    def summary
      "#{self.name} #{self.ticket_id}"
    end

    def self.command_regex
      bot_username        = Bot::Trello.config.username
      command_matcher     = SUPPORTED_COMMANDS.join('|')
      jira_matcher        = '[\d\w-]+'
      %r{\@#{bot_username}\s+(#{command_matcher})\s+(#{jira_matcher})}i
    end

    def self.extract(command_string)
      matches = command_string.match(self.command_regex)
      if matches
        name = matches[1].downcase
        ticket_id = matches[2].upcase
        return Bot::Command.new(name, ticket_id)
      else
        return nil
      end
    end

  end
end
