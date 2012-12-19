# Trello/Jira Integration Bot #

This project provides a solution to improve workflow between Trello and Jira. It is designed for an agile team that uses Trello for daily development and sprint planning, but must reference JIRA tickets related to external dependencies or bug reports.

The "bot" is a script and companion library that connects Trello and JIRA. It is intended to have it's own individual account in both systems (we call ours "jirabot"). This user is assigned to Trello cards and mentioned in comments. The script will scan Trello, and look for commands to track or import JIRA tickets. Tracked JIRA tickets are then polled for changes, and the Trello card is updated whenever a comment, attachment or resolution happens.

It's a great way to create cards in Trello based on JIRA tickets, or to track multiple dependent JIRA tickets in a Trello card. From experience, I have learned it is very hard to track issues in both systems at the same time, and this helps a lot.

## Features ##

Keeps Trello cards up-to-date with referenced JIRA tickets:

* ticket comments (posted with direct links)
* file attachments (imported directly)
* ticket resolution (as a comment)

There is also an `import` command, handy for creating new Trello cards from JIRA tickets. 

## Screenshot ##

![trello test board](http://dl.dropbox.com/u/385855/Screenshots/8pys.png)

## Installation ##

* A user `JiraBot` is created in Trello and added to one or more boards, and configured for OAuth API access.
* A JIRA user is created and added to one or more projects.
* Create a configuration file `config/config.yml`. See `config/config-example.yml` for details. You will need authentication details to access to the APIs of both Trello and JIRA. 
* set up a cron job to run the script `bin/trello_jira_bot` periodically (for example, every 15 minutes).

### Authentication Config Notes ##

How to get the authorization info needed in `config/config.yml`:

#### JIRA

Provide a username and password for a "bot" account in JIRA. At the moment this project does one-way sync, so the account can be read-only. This will use the REST API over HTTPS.

#### Trello

Create a 'bot' user on Trello, and add it to one or more boards. Trello requires OAuth, using 2-step authentication. Log in as the bot user and generate three pieces of info:

* secret: the second box from `https://trello.com/1/appKey/generate`
* key: the token you receive in a file downloaded from `https://trello.com/1/authorize?key=substitutewithyourapplicationkey&name=trello-jira-bot&response_type=token&scope=read,write,account&expiration=never`
* public_key: the first box from `https://trello.com/1/appKey/generate`

## Usage ##

A Trello card can be set up to track a set of JIRA tickets. The bot should have access to the board, and be assigned to the ticket. Commands are issued by adding comments to a ticket and mentioning the bot:

    @jirabot track SYS-1234

The bot will respond to with a comment on the ticket:

    SYS-1234 is now being tracked.

Once tracked, updates to the JIRA ticket will be posted to the Trello card as comments. 

* `track SYS-1536` : JIRAbot will begin tracking updates to this ticket on the given Trello card.

* `untrack JIRA: SYS-1536` : JIRAbot will stop tracking updates. You can also remove the bot from the card.

* `import JIRA: SYS-1536` : JIRAbot will import the title, description, ticket link, comments and attachments into the Trello card. This will overwrite any content that was there before. After that, the JIRA ticket will be tracked.

## Design ##

The [ruby-trello](https://github.com/jeremytregunna/ruby-trello) gem is used to communicate with Trello. The [rest-client](https://github.com/archiloque/rest-client) gem and some basic models are used for JIRA. 

ActiveSupport is used to handle configuration, and gain access to things like `.present?`.

There is no data or state infomation persisted locally. Sync status is determined by looking at event timestamps, and comparing them to when the bot last posted a comment.

## TODO

* Better error handling. Invalid ticket references cause the script to break.
* More efficient networking. Jira tickets could be cached or retained. Timeouts are not handled.

Add more commands:

* `track SYS-1234, ENG-1536` : handle multiple tickets as arguments
* `comment SYS-1536` : any text on the following lines is appended to the JIRA ticket as a new comment.
* `closes SYS-1536` : closes the given ticket (also support `reopen`, `wontfix`, etc.
* `assign SYS-1234` : assigns the JIRA ticket to the user who added the comment. There would need to be a Trello->Jira user mapping somewhere.

Maybe the `untrack` command is unneccessary. Removing the command comment, or the bot from the card has the same effect.

## Inspirations ##

* The [ruby-trello](https://github.com/jeremytregunna/ruby-trello) gem by Jeremy Tregunna was a big help in connecting to the Trello API. 
* An example hackday project called [devopsdays-checklist](https://github.com/jedi4ever/devopsdays-checklist) was a helpful starting point, especially for Trello authentication.
* The [JIRA API](https://developer.atlassian.com/display/JIRADEV/JIRA+REST+APIs) is surprisingly easy to use, with RESTful paths and predictable (but large) JSON responses.
