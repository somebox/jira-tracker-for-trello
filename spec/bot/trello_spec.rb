# encoding: utf-8
require 'spec_helper'

describe Bot::Trello do
  before do
    @member = Factory.build(:trello_member, :username => 'bot')
    Trello::Member.should_receive(:find).and_return(@member)
  end

  it "should instantiate" do
    @bot = Bot::Trello.new
    @bot.should be_instance_of Bot::Trello
    @bot.member.username.should == 'bot'
  end
end
