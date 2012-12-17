# Trello/Jira Integration Bot #

This gem provides a way to integrate workflow between Trello and Jira. It is designed for an agile team that uses Trello for daily development and sprint planning, but must reference JIRA tickets related to external dependencies. 

This bot will scan the Trello boards it belongs to, and look for JIRA cards numbers that are referenced in Trello comments. It can update comments, notice when a ticket is closed, re-opened, etc.

** Note:this app is still in heavy development. At the moment, it only imports comments to a test board **

## Screenshot ##

![trello test board](http://dl.dropbox.com/u/385855/Screenshots/7uev.png)

## Installation ##

* A user `JiraBot` is created in Trello and added to one or more boards, and configured for OAuth API access.
* A JIRA user is created and added to one or more projects.
* The configuration file `config/config.yml` is configured for access to the APIs of both Trello and JIRA.
* A script is configured to run periodically (via cron for instance).

## Usage ##

A Trello card can be set up to track a set of JIRA tickets. Commands are issued by adding comments to a ticket, and mentioning the bot. The bot will confirm commands with a comment on the ticket. Any updates to the JIRA ticket, such as status changes or comments, are posted on the Trello card as comments.

* `track SYS-1536` : JIRAbot will begin tracking updates to this ticket on the given Trello card.

* `untrack JIRA: SYS-1536` : JIRAbot will stop tracking updates.

* `import JIRA: SYS-1536` : JIRAbot will import the description and all comments into the Trello card. After that, the JIRA ticket will be tracked.

Todo:
* Add a rake task to act as a cron job, which can be called every minute or so for keeping things in sync.

## Ideas 

* import JIRA attachments as Trello attachments

more commands:

* `comment SYS-1536` : any text on the following lines is appended to the JIRA ticket as a new comment.
* `closes SYS-1536` : closes the given ticket (also support `reopen`, `wontfix`, etc.
* `track SYS-1234, ENG-1536` : handle multiple tickets as arguments
* `assign SYS-1234` : assigns the JIRA ticket to the user who added the comment. There would need to be a Trello->Jira user mapping somewhere.

## Configuration ##

The file `settings.yml` must be created for new installs of this package. Documentation to follow.

## Inspirations ##

* The [ruby-trello](https://github.com/jeremytregunna/ruby-trello) gem by Jeremy Tregunna was a big help in connecting to the Trello API. 
* An example hackday project called [devopsdays-checklist](https://github.com/jedi4ever/devopsdays-checklist) was a helpful starting point. 
* The [JIRA API](https://developer.atlassian.com/display/JIRADEV/JIRA+REST+APIs) is surprisingly easy to use, with RESTful paths and predictable (but large) JSON responses.
