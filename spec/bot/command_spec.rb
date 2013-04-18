# encoding: utf-8
require 'spec_helper'

describe Bot::Command do
  before do
  end

  it "should extract commands" do
    command = Bot::Command.extract('@bot track WS-1234')
    command.name.should == 'track'
    command.ticket_id.should == 'WS-1234'
  end

  it "should extract commands and tickets with a full url" do
    command = Bot::Command.extract('@bot track https://jira.mycorp.com/browse/WS-1234')
    command.name.should == 'track'
    command.ticket_id.should == 'WS-1234'    
  end

  it "should not extract unrecognized commands" do
    command = Bot::Command.extract('Hey what is going on with WS-1234?')
    command.should be_nil
  end
end
