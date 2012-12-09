module Jira
  class Comment
    attr_accessor :api_link, :author, :body, :created, :updated
    attr_accessor :ticket, :comment_id
    def initialize(json, ticket=nil)
      self.api_link = json["self"]
      self.author   = json["author"]["displayName"]
      self.body     = json["body"]
      self.created  = DateTime.parse(json["created"])
      self.updated  = DateTime.parse(json["updated"])
      self.ticket   = ticket
      self.comment_id = self.api_link.split('/').last  # last part of api link contains the comment id
    end

    def web_link
      "#{self.ticket.web_link}?focusedCommentId=#{self.comment_id}#comment-#{self.comment_id}"
    end

    def header
      "Comment by #{self.author} @ #{self.created.strftime('%R %v')}:"
    end
  end
end  
