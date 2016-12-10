# Jira Tracker for Trello

## NOTE: As of 2016-12-10, this project is still installable, and should be usable. However, I am not actively using it. I may not be able to respond to issues and bugs, but I am happy to review and merge pull requests. And if you would like to take over as a maintainer, just file an issue and let me know! -Jeremy


## Trello/Jira Integration

This project exists to improve workflow between Trello and Jira. It is perfect for an agile team that uses Trello for daily development and sprint planning, but must interact with JIRA for other teams or bug reports. From experience, I have learned it is very hard to track issues in both systems at the same time, and this solution helps.

A script is run periodically from cron. It interacts with JIRA and Trello using the web APIs. The "bot" is a Trello/Jira user that should have it's own individual account on both systems (we call ours "jirabot").

## Features ##

Keeps Trello cards up-to-date with referenced JIRA tickets:

* ticket comments (posted with direct links)
* file attachments (imported directly)
* ticket resolution (as a comment)

There is also an `import` command, handy for creating new Trello cards from JIRA tickets. 

## How it works

The intregration works by assigning the bot to Trello cards and mentioned it in comments. For instance, adding the comment `@jirabot track AX-123` to a Trello card will enable automatic updates from JIRA issue AX-123.

A script runs periodically, and checks relevant Trello tickets for tracking commands and status. Changes to tracked JIRA tickets (new comments, attachments or ticket resolutions) are posted to the Trello cards as comments.

## Screenshot ##

![trello test board](https://cloud.githubusercontent.com/assets/7750/21074990/b08242fe-bf07-11e6-8a09-253956e6a9e3.png)

## Installation ##

* Create a Trello user and add it to one or more boards.
* Create a JIRA user and give it access to one or more projects.
* Create a configuration file `config/config.yml`. (See `config/config-example.yml` for details). You will need authentication details to access to the APIs of both Trello and JIRA.
* Install all gems using `bundle install` in the folder of the repository.
* set up a cron job to run the script `bin/trello_jira_bot` periodically (for example, every 10 minutes). On os x run the following command:
`echo “10 * * * * $(pwd)/bin/trello-jira-bot” | crontab`

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

A Trello card can be set up to track a set of JIRA tickets. The bot should have access to the board, and be assigned to the ticket. Commands are issued by adding comments to a trello card and mentioning the bot by name:

    @jirabot track SYS-1234

The bot will respond to with a comment on the ticket:

    SYS-1234 is now being tracked.

Once tracked, updates to the JIRA ticket will be posted to the Trello card as comments. 

Here are available commands:

* `track SYS-1536` : JIRAbot will begin tracking updates to this ticket on the given Trello card.

* `untrack JIRA: SYS-1536` : JIRAbot will stop tracking updates. You can also remove the bot from the card.

* `import JIRA: SYS-1536` : JIRAbot will import the title, description, ticket link, comments and attachments into the Trello card. This will overwrite any content that was there before. After that, the JIRA ticket will be tracked.

## Design ##

The [ruby-trello](https://github.com/jeremytregunna/ruby-trello) gem is used to communicate with Trello. The [rest-client](https://github.com/archiloque/rest-client) gem and some basic models are used for JIRA. 

ActiveSupport is used to handle configuration, and gain access to things like `.present?`.

There is no data or state infomation persisted locally. Sync status is determined by looking at event timestamps, and comparing them to when the bot last posted a comment.


## TODO

* update documentation to be more generic for other configurations
* add some protection so that only authorized Trello organizations can be accessed. Trello has *very* open permissions: anyone can add any use to any board, which could be a security risk otherwise... :/

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
