$LOAD_PATH.unshift 'lib'

require 'awesome_print'
require 'trello'
require 'time'
require 'yaml'
require 'optparse'
require 'ap'
require 'rest_client'

require 'jira'

options = {
  :credentials => 'credentials.yml',
  :settings => 'settings.yml',
  :tasks => 'tasks.yml'
}

optparse = OptionParser.new do |opts|
  opts.on('-h','--help','Display this screen') do
    puts opts
    exit
  end
  opts.on('-c','--credentials FILENAME', 'Path to credentials yamlfile. Default: credentials.yml') do |f|
    options[:credentials] = f
  end
  opts.on('-s','--settings FILENAME', 'Path to settings yamlfile. Default: settings.yml') do |f|
    options[:settings] = f
  end
  opts.on('-t','--tasks FILENAME', 'Path to tasks yamlfile. Default: tasks.yml') do |f|
    options[:tasks] = f
  end
end

optparse.parse!

include Trello
include Trello::Authorization

todo_name = "To Do"

credentials={}
# Loading credentials
begin
  credentials = YAML.load_file(options[:credentials])
rescue Exception => e
  puts "Error #{e}"
  exit -1
end

settings={}
# Loading setting
begin
  settings = YAML.load_file(options[:settings])
rescue Exception => e
  puts "Error #{e}"
  exit -1
end

# @dday = settings[:dday]
# board_id = settings[:board_id]

# puts @dday
# Set authenttication
Trello::Authorization.const_set :AuthPolicy, OAuthPolicy
OAuthPolicy.consumer_credential = OAuthCredential.new credentials[:public_key],credentials[:secret]
OAuthPolicy.token = OAuthCredential.new credentials[:key], nil


def tracked_cards(member_name)
  member = Trello::Member.find(member_name)
  cards = member.cards
  jira_cards = []
  cards.each do |card|
    card.actions(:filter=>'commentCard').each do |action|
      p action
      text = action.data['text']
      if text.match(/track jira\:([\d\w-]+)/i)
        puts "JIRA #{$1} referenced"
        jira_cards << card
      end
    end
  end
  jira_cards
end

puts "updating data from JIRAs"

def update_comments(trello_card, jira_ticket)
  trello_card = data[:card]
  ticket = Jira::Ticket.get(data[:jira_id])
  puts "JIRA #{ticket.ticket_id} : #{ticket.summary}"
  ticket.comments.each do |comment|
    first_line = "**#{comment.created.strftime('%c')}: #{comment.author}**"
    card.add_comment("#{first_line}\n#{comment.body}")
  end
end

tracked_cards('jirabot').each do |card|
  
end


# def dday(days=0)

#   # If a dday has been speficied
#   unless @dday.nil?
#     d = @dday.split('-')
#     t = Time.local(d[2],d[1],d[0])+(3600*24)*days
#     return t
#   else
#     return nil
#   end
# end


# tasks = []
# begin
#   tasks = YAML.load_file(options[:tasks])
# rescue Exception => e
#   puts "Error #{e}"
#   exit -1
# end

# card_details = {
#   "closed" => false,
#   "idBoard" => board_id,
# }

# my_cards = []
# tasks.each do |t|
#   my_cards << t.merge(card_details)
# end

# # Find my board
# remote_board = Trello::Board.find(board_id)

# # Find the todo list
# remote_list_todo = nil
# remote_board.lists.each do |b|
#   if b.name == todo_name
#     remote_list_todo = b.id
#   end
# end

# if remote_list_todo.nil?
#   exit
# end

# # Load all cards from remote_board
# remote_cards = Hash.new
# remote_board.cards.each do |c|
#   remote_cards[c.name] = c
#   p c
# end


# my_cards.each do |c|
#   name = c[:name]
#   remote_card = remote_cards[name]
#   if remote_card.nil?

#     puts "Creating task #{name}"
#     card = Trello::Card.create(c.merge( { :list_id => remote_list_todo } ))
#     unless c[:due].nil?
#       puts "Setting due date #{dday(c[:due])}"
#       card.due = dday(c[:due])
#       card.update!
#     end

#     unless c[:checklist].nil?
#       c_name = "#{c[:name].strip}-checklist"
#       puts "Creating checklist #{c_name}"
#       checklist = Trello::Checklist.create({:name => "#{c_name}", :description => 'bla', :board_id => board_id })

#       c[:checklist].split(',').each do |i|
#         puts "Adding checklistitem #{i.strip} to #{c_name}"
#         checklist.add_item(i.strip)
#       end
#       checklist.update!
#       card.add_checklist(checklist)
#     end

#   else
#     puts "Task #{name} already created"
#   end
# end

