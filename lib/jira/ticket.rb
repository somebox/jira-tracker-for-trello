module Jira
  class Ticket
    attr_accessor :ticket_id, :api_link, :title, :description
    attr_accessor :issue_type, :fix_versions, :priority, :status, :project
    attr_accessor :created, :updated, :resolution_date

    # has many
    attr_accessor :comments, :attachments

    def initialize(json)
      fields = json["fields"]

      self.ticket_id        = json["key"]
      self.api_link         = json["self"]

      self.title            = fields["summary"]["value"]
      self.issue_type       = fields["issuetype"]["value"]["name"]
      self.fix_versions     = fields["fixVersions"].try(:[], "value").to_a.map{|v| v["name"]}
      self.priority         = fields["priority"] ? fields["priority"]["value"]["name"] : ''
      self.description      = fields["description"]["value"]
      self.status           = fields["status"]["value"]["name"]
      self.project          = fields["project"]["value"]["name"]
      self.created          = DateTime.parse(fields["created"]["value"])
      self.updated          = DateTime.parse(fields["updated"]["value"])
      self.resolution_date  = fields["resolutiondate"] ? DateTime.parse(fields["resolutiondate"]["value"]) : nil

      self.attachments      = fields["attachment"]["value"].map do |attachment_json| 
        Jira::Attachment.new(attachment_json)
      end

      self.comments = fields["comment"]["value"].map do |comment_json|
        Jira::Comment.new(comment_json)
      end

      self
    end

    def self.get(ticket_id)
      json = Jira::Client.get(ticket_id)
      self.new(json)
    end

    def self.exists?(ticket_id)
      begin
        Jira::Client.get(ticket_id) && true
      rescue RestClient::ResourceNotFound
        warn("Jira ticket #{ticket_id} not found")
        false
      end
    end

    def web_link
      "#{Jira::Client.config.site}/browse/#{self.ticket_id}"
    end

    def comment_web_link(comment)
      "#{self.web_link}?focusedCommentId=#{comment.comment_id}#comment-#{comment.comment_id}"
    end

    def summary
      "JIRA #{self.ticket_id}: #{self.title}"
    end

    def comments_since(date)
      self.comments.select{|c| c.created > date}
    end

    def attachments_since(date)
      self.attachments.select{|a| a.created > date}
    end
  end
end  
