module Jira

  class Client
    include ActiveSupport::Configurable
    config_accessor :site, :user, :password

    def self.client
      @client ||= RestClient::Resource.new("#{self.class.site}/rest/api/latest/issue/", 
                  :user => self.class.config.user,
                  :password => self.class.config, 
                  :content_type => 'application/json'
                )
    end

    def self.get(ticket_id)
      response = self.client[ticket_id].get
      JSON.parse(response.body)
    end
  end
end
