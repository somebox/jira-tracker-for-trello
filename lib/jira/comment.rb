module Jira
  class Comment
    attr_accessor :api_link, :author, :body, :created, :updated
    attr_accessor :comment_id, :web_link

    def initialize(json)
      self.api_link = json["self"]
      self.author   = json["author"]["displayName"]
      self.body     = json["body"]
      self.created  = DateTime.parse(json["created"])
      self.updated  = DateTime.parse(json["updated"])
      self.web_link   = web_link
      self.comment_id = self.api_link.split('/').last  # last part of api link contains the comment id
    end

    def header
      "*Comment by* #{self.author}, **#{self.created.strftime('%v %R')}**:"
    end
  end
end  
