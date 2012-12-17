# encoding: utf-8
require 'spec_helper'

describe Bot::Trello do
  before do
    @member = Factory.build(:trello_member, :username => 'bot')
    Trello::Member.should_receive(:find).and_return(@member)
    @bot = Bot::Trello.new
  end

  it "should instantiate" do
    @bot.should be_instance_of Bot::Trello
  end

  it "should set the username" do
    @bot.member.username.should == 'bot'
  end

  it "should set up the trello cards" do
    @bot.member.cards.should == []
  end

end
