# encoding: utf-8
require 'spec_helper'


describe Bot::CommentScanner do
  before do
    @user_comment_1 = Factory.build(:command_comment_track) 
    @bot_comment    = Factory.build(:bot_comment) 
    @user_comment_2 = Factory.build(:user_comment)
    @user_comment_3 = Factory.build(:command_comment_untrack)
    comments = [@user_comment_1, @bot_comment, @user_comment_2, @user_comment_3]

    @scanner = Bot::CommentScanner.new(comments, '12345') # bot user id
  end

  context "comments" do
    it "should find bot comments" do
      @scanner.bot_comments.should == [@bot_comment]
    end

    it "should find user comments" do
      @scanner.user_comments.should == [@user_comment_1, @user_comment_2, @user_comment_3]
    end

    it "should find last bot comment" do
      @scanner.last_bot_comment.should == @bot_comment
    end

    it "should find command comments" do
      @scanner.command_comments.should == [@user_comment_1, @user_comment_3]
    end

    it "should find new command comments" do
      @scanner.new_command_comments.should == [@user_comment_3]
    end
  end

  context "commands" do
    it "returns commands" do
      @scanner.commands.size.should == 2
      @scanner.commands.first.class.should == Bot::Command
    end

    it "returns new commands" do
      @scanner.new_commands.size.should == 1
      @scanner.new_commands.first.name.should == 'untrack'
      @scanner.new_commands.first.ticket_id.should == 'WS-9999'
    end
  end
end
