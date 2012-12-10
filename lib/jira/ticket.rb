module Jira
  class Ticket
    attr_accessor :ticket_id, :api_link, :title, :description
    attr_accessor :issue_type, :fix_versions, :priority, :status, :project
    attr_accessor :created, :updated
    attr_accessor :comments

    def initialize(json)
      fields = json["fields"]

      self.ticket_id        = json["key"]
      self.api_link         = json["self"]

      self.title            = fields["summary"]["value"]
      self.issue_type       = fields["issuetype"]["value"]["name"]
      self.fix_versions     = fields["fixVersions"]["value"].map{|v| v["name"]}
      self.priority         = fields["priority"]["value"]["name"]
      self.description      = fields["description"]["value"]
      self.status           = fields["status"]["value"]["name"]
      self.project          = fields["project"]["value"]["name"]
      self.created          = DateTime.parse(fields["created"]["value"])
      self.updated          = DateTime.parse(fields["updated"]["value"])

      self.comments = fields["comment"]["value"].map do |comment_json|
        Jira::Comment.new(comment_json, self)
      end

      self
    end

    def web_link
      "#{Jira::Client.config.site}/browse/#{self.ticket_id}"
    end

    def summary
      "JIRA #{self.ticket_id} : #{self.title}"
    end

    def self.get(ticket_id)
      json = Jira::Client.get(ticket_id)
      self.new(json)
    end
  end
end  
