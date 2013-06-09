def load_fixture(name)
	content = File.read(File.expand_path("../../fixtures/#{name}", __FILE__))
	JSON.parse(content)
end

def stub_jira_ticket_request(ticket_id)
  fixture = load_fixture("jira/#{ticket_id}.json")
  Jira4::Client.should_receive(:get).with(ticket_id).at_least(:once).and_return(fixture)
end
