module Jira4
  class Attachment
    attr_accessor :filename, :author, :content, :thumbnail, :mime_type, :created, :size

    def initialize(json)
      self.filename   = json["filename"]
      self.content    = json["content"]
      self.thumbnail  = json["thumbnail"]
      self.author     = json["author"]["displayName"]
      self.mime_type  = json["mimeType"]
      self.size       = json["size"]
      self.created    = DateTime.parse(json["created"])
    end

    def download
      Jira4::Client.download(self.content)
    end
  end
end
