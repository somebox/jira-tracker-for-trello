# encoding: utf-8
require 'spec_helper'

describe Bot::Command do
  before do
  end

  it "should recognize commands" do
    command = Bot::Command.scan('jirabot', '@jirabot track WS-1234')
    command.name.should == 'track'
    command.ticket_id.should == 'WS-1234'
  end

  it "should reject unrecognized commands" do
    command = Bot::Command.scan('jirabot', 'Hey what is going on with WS-1234?')
    command.should be_nil
  end
end
