# Trello/Jira Integration Bot #

This gem provides a way to integrate workflow between Trello and Jira. It is designed for an agile team that uses Trello for daily development and sprint planning, but must reference JIRA tickets related to external dependencies. 

## Installation ##

* A user `JiraBot` is created in Trello and added to one or more boards, and configured for OAuth API access.
* A JIRA user is created and added to one or more projects.
* The configuration file `settings.yml` is configured for access to the APIs of both Trello and JIRA.
* A script is configured to run periodically.

## Usage ##

Within Trello, commands are issued by adding comments to a ticket. A Trello card can be configured to track a set of JIRA tickets. Any updates to the JIRA ticket, such as status changes or comments, are posted on the Trello card as comments.

* `track JIRA: SYS-1536` : JIRAbot will begin tracking updates to this ticket on the given Trello card.
* `untrack JIRA: SYS-1536` : JIRAbot will stop tracking updates.
* `import JIRA: SYS-1536` : JIRAbot will import the description and all comments into the Trello card. After that, the JIRA ticket will be tracked.

Todo:
* `comment JIRA: SYS-1536` : any text on the following lines is appended to the JIRA ticket as a new comment.
* `closes JIRA: SYS-1536` : closes the given ticket (also support `reopen`, `wontfix`, etc.
* `track JIRA: SYS-1234, ENG-1536` : handle multiple tickets as arguments
* `assign JIRA: SYS-1234` : assigns the JIRA ticket to the user who added the comment. There would need to be a Trello->Jira user mapping somewhere.

## Configuration ##

The file `settings.yml` must be created for new installs of this package.
