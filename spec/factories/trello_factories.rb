
# Trello
# ------

# Trello::Member

Factory.define :trello_member, :class=>'OpenStruct' do |f|
  f.username 'user_123'
  f.id 'abc123'
  f.cards []
end

# Trello::Card

Factory.define :trello_card, :class => 'OpenStruct' do |f|
  f.actions []
  f.name 'card name'
  f.description 'card long description'
end

# Trello::Action
# 
# Comments are actions on a Trello card.
#
Factory.define :user_comment, :class => 'OpenStruct' do |f|
  f.member_creator_id 'user_123'
  f.data({'text'=>'comment_text'})
  f.date DateTime.now
end

Factory.define :command_comment_track, :class => 'OpenStruct' do |f|
  f.member_creator_id 'abcde'
  f.date DateTime.parse('2012-10-7')
  f.data({'text' => '@bot track WS-9999'})
end

Factory.define :command_comment_untrack, :class => 'OpenStruct' do |f|
  f.member_creator_id 'abcde'
  f.date DateTime.parse('2012-10-14')
  f.data({'text' => "@bot untrack WS-9999\nThis problem is fixed."})
end

Factory.define :bot_comment, :class => 'OpenStruct' do |f|
  f.member_creator_id '12345'
  f.date DateTime.parse('2012-10-9')
  f.data({'text' => 'Now tracking WS-9999. Status: open. http://jira.example.com/browse/WS-9999?commentId=12345#comment_12345'})
end
