# encoding: utf-8
require 'spec_helper'

# For these tests, Trello member '12345' is @jirabot

describe Bot::TrackedCard do
  before do
    @member = Factory.build(:trello_member, :username => 'bot', :id => '12345')
    Trello::Member.should_receive(:find).and_return(@member)
    @bot = Bot::Trello.new
    @trello_card = Factory.build(:trello_card)
    @tracked_card = Bot::TrackedCard.new(@trello_card, @bot)    
  end

  it "should initialize" do
    @tracked_card.trello_bot.should == @bot
    @tracked_card.trello_card.should == @trello_card
  end

  context "comments" do
    before do
      @user_comment_1 = Factory.build(:command_comment_track) 
      @bot_comment    = Factory.build(:bot_comment) 
      @user_comment_2 = Factory.build(:user_comment)
      @user_comment_3 = Factory.build(:command_comment_close)
      comments = [@user_comment_1, @bot_comment, @user_comment_2, @user_comment_3]
      @tracked_card.should_receive(:comments).at_least(:once).and_return(comments)
    end

    it "should find bot comments" do
      @tracked_card.bot_comments.should == [@bot_comment]
    end

    it "should find user comments" do
      @tracked_card.user_comments.should == [@user_comment_1, @user_comment_2, @user_comment_3]
    end

    it "should find last bot comment" do
      @tracked_card.last_bot_comment.should == @bot_comment
    end

    it "should find command comments" do
      @tracked_card.command_comments.should == [@user_comment_1, @user_comment_3]
    end

    it "should find new command comments" do
      @tracked_card.new_command_comments.should == [@user_comment_3]
    end
  end
end
