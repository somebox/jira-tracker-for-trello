module Bot
  class Command
    MATCHER = /\@#{@bot.username}\/i)\s+(track|untrack)\s+([\d\w-]+)/i
    
    def initialize(command_string)
      matches = command_string.match(MATCHER)
      @command = matches.first.downcase
      @ticket_id = matches.second.upcase
      @ticket = Jira::Ticket.get(ticket_id)
    end
  end
end
