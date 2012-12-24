module Bot
  # Trello Comment Scanner
  #
  # This class sorts and finds comments attached to a trello card.
  # It is used to find user commands and previous bot comments.
  #
  # Comments are Trello::Action instances, ordered newest to oldest.
  # 
  class CommentScanner
    attr_accessor :comments
    attr_accessor :bot_user_id 

    def initialize(comments, bot_user_id)
      self.comments = comments
      self.bot_user_id = bot_user_id
    end

    def bot_comments
      self.comments.select{|c| c.member_creator_id == self.bot_user_id}
    end

    def last_bot_comment
      self.bot_comments.first
    end

    def user_comments
      self.comments - self.bot_comments
    end

    def command_comments
      self.user_comments.select{|comment| CommentScanner.extract_command(comment)}
    end

    def new_command_comments
      self.command_comments.select{|c| c.date > self.last_posting_date}
    end

    def last_posting_date
      self.last_bot_comment ? self.last_bot_comment.date : DateTime.parse('1-1-2000')
    end

    # Bot::Command convenience methods

    def commands
      self.command_comments.map{|comment| CommentScanner.extract_command(comment)}
    end

    def new_commands
      self.new_command_comments.map{|comment| CommentScanner.extract_command(comment)}
    end

    def self.extract_command(comment)
      Bot::Command.extract(comment.data['text'])
    end
  end
end
