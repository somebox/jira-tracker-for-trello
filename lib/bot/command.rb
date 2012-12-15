module Bot
  class Command
    attr_accessor :name, :ticket_id

    SUPPORTED_COMMANDS = %w(track untrack comment close import)

    def initialize(name, ticket_id)
      self.name = name
      self.ticket_id = ticket_id
    end

    def self.scan(bot_username, command_string)
      command_matcher     = SUPPORTED_COMMANDS.join('|')
      jira_matcher        = '[\d\w-]+'
      command_regex       = %r{\@#{bot_username}\s+(#{command_matcher})\s+(#{jira_matcher})}i
      matches = command_string.match(command_regex)
      if (matches)
        name = matches[1].downcase
        ticket_id = matches[2].upcase
        return Bot::Command.new(name, ticket_id)
      end
    end

  end
end
