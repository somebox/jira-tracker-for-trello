module Bot
  class TrackedCard
    attr_accessor :trello_card, :trello_bot

    def initialize(trello_card, trello_bot)
      self.trello_card = trello_card
      self.trello_bot = trello_bot
    end

    # comments are really Trello::Action instances, ordered newest to oldest
    def comments
      @comments ||= self.trello_card.actions(:filter=>'commentCard')
    end

    def bot_comments
      self.comments.select{|c| c.member_creator_id == self.trello_bot.user_id}
    end

    def user_comments
      self.comments - self.bot_comments
    end

    def command_comments
      self.user_comments.select do |comment| 
        text = comment.data['text']
        Bot::Command.scan(self.trello_bot.username, text)
      end
    end

    def last_bot_comment
      self.bot_comments.first
    end

    def new_command_comments
      if last_bot_comment
        self.command_comments.select{|c| c.date > self.last_bot_comment.date}
      else
        self.command_comments
      end
    end
  end
end
