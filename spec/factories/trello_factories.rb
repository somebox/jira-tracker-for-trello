
# Trello
Factory.define :trello_member, :class=>'OpenStruct' do |f|
  f.username 'user_123'
  f.cards []
end

Factory.define :trello_card, :class => 'OpenStruct' do |f|
  f.actions []
end

Factory.define :trello_actions, :class => 'OpenStruct' do |f|
  f.member_creator_id 'user_123'
  f.data {{'text'=>'comment_text'}}
  f.date DateTime.now
end



