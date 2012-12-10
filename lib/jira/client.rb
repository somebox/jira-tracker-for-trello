module Jira

  class Client
    include ActiveSupport::Configurable
    config_accessor :site, :user, :password

    def self.client
      @client ||= RestClient::Resource.new("#{self.config.site}/rest/api/latest/issue/", 
                  :user => self.config.user,
                  :password => self.config.password, 
                  :content_type => 'application/json'
                )
    end

    def self.get(ticket_id)
      response = self.client[ticket_id].get
      JSON.parse(response.body)
    end
  end
end
