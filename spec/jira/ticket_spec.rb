# encoding: utf-8
require 'spec_helper'

describe Jira::Ticket do
  before do
    stub_jira_ticket_request('WS-1299')
    stub_jira_ticket_request('WS-1230')

    @ticket = Jira::Ticket.get('WS-1299')
    @ticket_with_many_comments = Jira::Ticket.get('WS-1230')
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

  it 'should parse comments' do
    @ticket.comments.size.should == 1
    @ticket.comments.first.body.should =~ /duplicate of/
    @ticket.comments.first.created.strftime('%F %T').should == '2012-10-24 17:13:44'
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
end
