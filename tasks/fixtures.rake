
desc "update test fixtures from JIRA"
task :update_fixtures do
	Dir.glob('spec/fixtures/jira/*').each do |filename|
		ticket_id = File.basename(filename).split('.').first
		File.open("spec/fixtures/jira/#{ticket_id}.json","w") do |file|
		  file.write(Jira::Client.get(ticket_id).to_json)
		end
	end
end
