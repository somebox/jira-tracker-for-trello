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

    # Downloads a file. Returns a Tempfile 
    def self.download(url)
      FileUtils.mkdir_p('tmp/attachments')
      file = File.open("tmp/attachments/#{File.basename(url)}", 'w')
      file.binmode
      file.write RestClient::Request.execute(
        :method   => :get, 
        :url      => url, 
        :user     => Jira::Client.config.user, 
        :password => Jira::Client.config.password
      )
      file.close
      File.open(file.path)
    end
  end
end
