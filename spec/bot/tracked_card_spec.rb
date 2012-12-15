# encoding: utf-8
require 'spec_helper'

describe Bot::TrackedCard do
  before do
  end

  it "should initialize" do
    @card = Bot::TrackedCard.new(Factory.build(:trello_card), 'bot')
    @card.trello_bot_username.should == 'bot'
  end
end
