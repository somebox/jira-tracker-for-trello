# encoding: utf-8
require 'spec_helper'

describe 'jira 4' do
  before do
    Jira::Ticket.config.jira_version = 4
  end

  describe Jira::Ticket do
    before do
      stub_jira_ticket_request('WS-1299')
      stub_jira_ticket_request('WS-1230')
      stub_jira_ticket_request('WS-1080')

      @ticket = Jira::Ticket.get('WS-1299')
      @ticket_with_many_comments = Jira::Ticket.get('WS-1230')
      @ticket_with_attachments = Jira::Ticket.get('WS-1080')
    end

    it 'should parse the ticket id' do
      @ticket.ticket_id.should == 'WS-1299'
    end

    it 'should parse the api link' do
      @ticket.api_link.should == 'https://jira.example.com/rest/api/latest/issue/WS-1299'
    end

    it 'should parse the title' do
      @ticket.title.should == 'wrong slots after calculating a route'
    end

    it 'should check if a ticket exists' do
      Jira::Client.should_receive(:get).and_raise(RestClient::ResourceNotFound)
      Jira::Ticket.exists?('ws-404').should == false
    end

    it 'should parse comments' do
      @ticket.comments.size.should == 1
      @ticket.comments.first.body.should =~ /duplicate of/
      @ticket.comments.first.created.strftime('%F %T').should == '2012-10-24 17:13:44'

      @ticket_with_many_comments.comments.size.should == 5
    end

    it 'should parse the status' do
      @ticket.status.should == 'Closed'
    end

    it 'should parse dates' do
      @ticket.created.strftime('%F %T').should == '2012-10-02 15:18:40'
      @ticket.updated.strftime('%F %T').should == '2012-10-24 17:13:44'
    end

    it 'should find comments since a given date' do
      comments = @ticket_with_many_comments.comments_since(DateTime.parse('2012-11-01'))
      comments.count.should == 3
    end

    it 'should find attachments' do
      @ticket_with_attachments.attachments.count.should == 1
    end
  end
end

describe "jira 5" do
  before do
    Jira::Ticket.config.jira_version = 5
  end

  describe "ticket" do
    before do
      stub_jira_ticket_request('SYS-1916')
      #stub_jira_ticket_request('WS-1230')
      #stub_jira_ticket_request('WS-1080')

      @ticket = Jira::Ticket.get('SYS-1916')
      #@ticket_with_many_comments = Jira::Ticket.get('WS-1230')
      #@ticket_with_attachments = Jira::Ticket.get('WS-1080')
    end

    it "parses the description" do
      @ticket.description.should =~ /local.ch main website dispatcher/
    end

    it "parses the issue_type" do
      @ticket.issue_type.should == "Operations"
    end

    it "parses the status" do
      @ticket.status.should == "Closed"
    end

    it "parses the project" do
      @ticket.project.should == "System Engineering"
    end

    it "parses the created date" do
      @ticket.created.to_s.should == "2012-08-07T09:53:22+02:00"
    end

    it "parses the updated date" do
      @ticket.updated.to_s.should == "2013-01-04T11:03:48+01:00"
    end

    it "parses the updated date" do
      @ticket.resolution_date.to_s.should == "2012-10-01T17:38:08+02:00"
    end

    it "parses the priority" do
      @ticket.priority.should == "Minor"
    end

    

  end
end
