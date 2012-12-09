require 'rest_client'
require 'json'

module Jira
  SITE = 'https://jira.local.ch'
  USER = 'automator'
  PASS = 'y7#l;<cA@3dnsbDjfg=_hf|"q%**dgHg'

  class Client
    def self.client
      @client ||= RestClient::Resource.new("#{SITE}/rest/api/latest/issue/", 
                  :user => USER, 
                  :password => PASS, 
                  :content_type => 'application/json'
                )
    end

    def self.get(ticket_id)
      response = self.client[ticket_id].get
      JSON.parse(response.body)
    end
  end

  class Comment
    attr_accessor :api_link, :author, :body, :created, :updated
    def initialize(json)
      self.api_link = json["self"]
      self.author   = json["author"]["displayName"]
      self.body     = json["body"]
      self.created  = DateTime.parse(json["created"])
      self.updated  = DateTime.parse(json["updated"])
    end
  end

	class Ticket
    attr_accessor :ticket_id, :web_link, :api_link, :summary, :description
    attr_accessor :issue_type, :fix_versions, :priority, :status, :project
    attr_accessor :created, :updated
    attr_accessor :comments

    def initialize(json)
      fields = json["fields"]

      self.ticket_id        = json["key"]
      self.web_link         = "#{SITE}/browse/#{self.ticket_id}"
      self.api_link         = json["self"]

      self.summary          = fields["summary"]["value"]
      self.issue_type       = fields["issuetype"]["value"]["name"]
      self.fix_versions     = fields["fixVersions"]["value"].map{|v| v["name"]}
      self.priority         = fields["priority"]["value"]["name"]
      self.description      = fields["description"]["value"]
      self.status           = fields["status"]["value"]["name"]
      self.project          = fields["project"]["value"]["name"]
      self.created          = DateTime.parse(fields["created"]["value"])
      self.updated          = DateTime.parse(fields["updated"]["value"])

      self.comments = fields["comment"]["value"].map do |comment_json|
        Jira::Comment.new(comment_json)
      end

      self
    end

    def self.get(ticket_id)
      json = Jira::Client.get(ticket_id)
      self.new(json)
    end
  end
end
