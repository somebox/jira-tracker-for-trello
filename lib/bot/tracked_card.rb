module Bot
  class TrackedCard
    def initialize(trello_card, bot)
      @trello_card = trello_card
      @bot = bot
    end

    # comments are really Trello::Action instances, ordered newest to oldest
    def comments
      @comments ||= @trello_card.actions(:filter=>'commentCard')
    end

    def bot_comments
      self.comments.select{|c| c.member_creator_id == @bot.id}
    end

    def command_comments
      self.user_comments.select{|comment| comment.data['text'].match(Bot::Command::MATCHER)}
    end

    def last_bot_comment
      self.bot_comments.first
    end

    def new_commands
      if last_bot_comment
        self.command_comments.select{|c| c.date > last_bot_comment.date}
      else
        self.command_comments
      end
    end
  end
end
