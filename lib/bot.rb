class Bot
  def self.update_comments(trello_card, jira_ticket)
    puts jira_ticket.summary
    jira_ticket.comments.each do |comment|
      text = [comment.header, comment.body, comment.web_link].join("\n")
      trello_card.add_comment("#{jira_ticket.ticket_id}: #{text}")
    end
  end

  def self.scan_trello_cards(member_name)
    member = Trello::Member.find(member_name)
    cards = member.cards
    cards.each do |card|
      card.actions(:filter=>'commentCard').each do |action|
        text = action.data['text']
        if text.match(/(track|import|untrack) JIRA\:([\d\w-]+)/i)
          command = $1.downcase
          ticket = Jira::Ticket.get($2)
          update_comments(card, ticket)
        end
      end
    end
  end

end
