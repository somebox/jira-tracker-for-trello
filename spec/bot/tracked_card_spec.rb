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
    Jira4::Ticket.stub(:exists?).and_return(true)
  end

  it "should initialize" do
    @tracked_card.trello_bot.should == @bot
    @tracked_card.trello_card.should == @trello_card
  end

  context "ticket tracking status" do
    it "should add to tracked cards" do
      @tracked_card.track_jira('WS-1234')
      @tracked_card.jira_tickets.should == ['WS-1234']
    end

    it "should remove from tracked cards" do
      @tracked_card.jira_tickets = ['WS-1234']
      @tracked_card.untrack_jira('WS-1234')

      @tracked_card.jira_tickets.should == []
    end

    it "should handle multiple updates" do
      @tracked_card.jira_tickets.should == []

      @tracked_card.track_jira('WS-1234')
      @tracked_card.track_jira('WS-9999')

      @tracked_card.jira_tickets.should == ['WS-1234', 'WS-9999']

      @tracked_card.untrack_jira('WS-1234')      
      @tracked_card.track_jira('WS-9999')

      @tracked_card.jira_tickets.should == ['WS-9999']
    end

    it "updates tracking status" do
      commands = [
        Bot::Command.new('track','WS-1234'),
        Bot::Command.new('import', 'WS-4444')
      ]
      @tracked_card.should_receive(:commands).and_return(commands)
      @tracked_card.update_tracking_status
      @tracked_card.jira_tickets.should == ['WS-1234','WS-4444']
    end
  end

  context "ticket command responses" do
    it "should add to tracked cards" do
      @tracked_card.trello_card.should_receive(:add_comment).at_least(:once).with(/WS-1234 is now being tracked/)

      @command = Bot::Command.new('track','WS-1234')
      @tracked_card.run(@command)
    end

    it "should remove from tracked cards" do
      @tracked_card.trello_card.should_receive(:add_comment).at_least(:once).with(/WS-1234 is no longer being tracked/)
      @tracked_card.jira_tickets = ['WS-1234']

      @command = Bot::Command.new('untrack','WS-1234')
      @tracked_card.run(@command)
    end
  end

  context "update card from jira" do
    before do
      stub_jira_ticket_request('WS-1230')
      @tracked_card.should_receive(:last_posting_date).and_return(DateTime.parse('2012-11-01'))
    end

    it "should post comments" do
      @tracked_card.trello_card.should_receive(:add_comment).exactly(3).times
      @tracked_card.update_comments_from_jira('WS-1230')
    end
  end

  context "import card from jira" do
    before do
      stub_jira_ticket_request('WS-1230')
      @tracked_card.trello_card.should_receive(:save).and_return(true)
    end

    it "should import details" do
      @tracked_card.import_content_from_jira('WS-1230')
      @tracked_card.trello_card.name.should =~ /WS-1230: Adress mismatch on map.local.ch/
    end
  end

end
