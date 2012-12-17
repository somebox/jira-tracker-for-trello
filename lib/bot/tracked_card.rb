=begin
  
Usage:

    card = Bot::TrackedCard.new(trello_card, trello_bot)
    card.tracked_jira_tickets     # => [<Jira::Ticket ...>, ]
    card.process_new_commands!

=end
module Bot
  class TrackedCard
    attr_accessor :trello_card, :trello_bot
    attr_accessor :jira_tickets, :last_bot_update

    def initialize(trello_card, trello_bot)
      self.trello_card = trello_card
      self.trello_bot = trello_bot
      self.jira_tickets = []
    end

    def summary
      title = self.trello_card.description
      title = '(no description)' if title.blank?
      "##{self.short_id}: #{title}"
    end

    def short_id
      self.trello_card.short_id
    end

    # Trello Comments
    # ---------------
    #
    # Comments are really Trello::Action instances, ordered newest to oldest.
    # These methods help sort out which comments we need to process.
    # 
    def comments
      @comments ||= self.trello_card.actions(:filter=>'commentCard')
    end

    def bot_comments
      self.comments.select{|c| c.member_creator_id == self.trello_bot.user_id}
    end

    def last_bot_comment
      self.bot_comments.first
    end

    def user_comments
      self.comments - self.bot_comments
    end

    def command_comments
      self.user_comments.select do |comment|
        text = comment.data['text']
        Bot::Command.extract(text) != nil
      end
    end

    def new_command_comments
      self.command_comments.select{|c| c.date > self.last_posting_date}
    end

    def last_posting_date
      self.last_bot_comment ? self.last_bot_comment.date : DateTime.parse('1-1-2000')
    end

    def add_comment(text)
      self.trello_card.add_comment(text)
    end

    def update_card_from_jira(jira_ticket)
      is_updated = false
      jira_ticket.comments_since(self.last_posting_date).each do |comment|
        link = jira_ticket.comment_web_link(comment)
        text = [comment.header, comment.body, link].join("\n")
        self.add_comment("#{jira_ticket.ticket_id}: #{text}")
        is_updated = true
      end
      is_updated
    end

    # Bot Commands
    # ------------
    #
    # Commands are given in Trello card comments by users. They must mention the bot:
    #
    #    @jirabot track WS-1234
    #    @jirabot untrack WS-1234    
    #
    def commands
      text_commands = self.command_comments.map{|c| c.data['text']}
      text_commands.map do |text|
        Bot::Command.extract(text)
      end
    end

    def new_commands
      text_commands = self.new_command_comments.map{|c| c.data['text']}
      text_commands.map do |text|
        Bot::Command.extract(text)
      end
    end

    def track_jira(ticket_id)
      self.jira_tickets.push(ticket_id)
      self.jira_tickets.uniq!
    end

    def untrack_jira(ticket_id)
      self.jira_tickets.delete(ticket_id)
    end

    def update_tracking_status
      # update tracking status
      self.commands.each do |command|
        case command.name
        when 'track'
          self.track_jira(command.ticket_id)
        when 'untrack'
          self.untrack_jira(command.ticket_id)
        end
      end
    end

    def run(command)
      case command.name
      when 'track'
        self.trello_card.add_comment("JIRA ticket #{command.ticket_id} is now being tracked.")
      when 'untrack'
        self.trello_card.add_comment("JIRA ticket #{command.ticket_id} is no longer being tracked.")
      when 'comment'
      when 'close'
        warn "'#{command.name}' command not implemented"
      else
        warn "unknown command '#{command.name}'"
      end
    end
 
  end
end
