module Jira4
  class Client
    include ActiveSupport::Configurable
    config_accessor :site, :user, :password

    CACHE_OPTIONS = {
      :cache => 60, 
      :valid => 600
    }

    class << self
      attr_accessor :cache
    end

    def self.client
      @client ||= RestClient::Resource.new("#{self.config.site}/rest/api/latest/issue/", 
                  :user => self.config.user,
                  :password => self.config.password, 
                  :content_type => 'application/json'
                )
    end

    def self.get(ticket_id)
      begin
        APICache.get("jira_ticket_#{ticket_id}", CACHE_OPTIONS) do
          response = self.client[ticket_id].get
          JSON.parse(response.body)
        end
      rescue APICache::CannotFetch
        raise RestClient::ResourceNotFound
      end
    end

    # Downloads a file. Returns a Tempfile 
    def self.download(url)
      FileUtils.mkdir_p('tmp/attachments')
      file = File.open("tmp/attachments/#{File.basename(url)}", 'w')
      file.binmode
      file.write RestClient::Request.execute(
        :method   => :get, 
        :url      => url, 
        :user     => Jira4::Client.config.user, 
        :password => Jira4::Client.config.password
      )
      file.close
      File.open(file.path)
    end
  end
end
