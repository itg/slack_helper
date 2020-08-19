# slack_helper
A Docker image to streamline sending a message to Slack.

## Examples

### Docker CLI

```
docker run --rm midmich/slack_helper:latest "Message to send to Slack"
```

```
docker run --rm --env SLACK_TEXT="A different way to indicate which message to Slack" midmich/slack_helper:latest
```

### Docker Compose

A minimum viable `docker-compose.yml`

```
version: '3.2'
services:
    slack:
        image: midmich/slack_helper:latest
        environment:
            SLACK_WEBHOOK_URL: https://hooks.slack.com/services/your/webhook/path
            SLACK_TEXT: "foo bar baz"
```

## Usage Note: Multiple In, Single Out

If you provide both `SLACK_TEXT` and a message parameter, only the `SLACK_TEXT` value is used

For example, this command will send "message foo" to Slack:
```
docker run --rm --env SLACK_TEXT="message foo" midmich/slack_helper:latest "message bar"
```

## Run-Time Configuration

### Required Enviroment variables

* `SLACK_WEBHOOK_URL`  
    [String] The Webhook URL to which to send the message. [Documentation @ Slack: Getting started with Incoming Webhooks](https://api.slack.com/messaging/webhooks?nojsmode=1#getting_started)

### Optional Environment variables
* `SLACK_TEXT`
* `SLACK_WEBHOOK_CHANNEL`  
    [String] The Slack channel to which to send the message. [Documentation @ Slack: Runtime Customizations > `channel`](https://api.slack.com/legacy/custom-integrations/incoming-webhooks#legacy-customizations). Examples include channel ID (`C8UJ12P4P`), user DM (`@username`), or channel (`#testing`).
* `SLACK_WEBHOOK_USER`  
    [String] The username to display in Slack as the poster of the message. [Documentation @ Slack: Runtime Customizations > `username`](https://api.slack.com/legacy/custom-integrations/incoming-webhooks#legacy-customizations)
* `SLACK_WEBHOOK_ICON`  
    [String] The URL of the image to display in Slack. [Documentation @ Slack: Runtime Customizations > `icon_url`](https://api.slack.com/legacy/custom-integrations/incoming-webhooks#legacy-customizations)
* `DEBUG_LEVEL`  
    [Integer] Controls the amount and type of logging information sent. Compared to [the defined output levels](source/ping.sh#L4).

The `SLACK_WEBHOOK_*` variables are typically stored somewhere (e.g. in Gitlab CI/CD configuration variables) and usually do not need to be explicitly specified in `.env` or `docker-compose.yml`.


### Internal Implementation

The internal mechanism used to send the message to Slack, Incoming Webhooks, has been marked as "Legacy" by Slack and could be deprecated/discontinued in the future.

This image continues to use this "Legacy" mechanism because of the ease of use and features that are not possible in the current, supported mechanism.

From [Slack's current version documentation](https://api.slack.com/messaging/webhooks#advanced_message_formatting):

> You **cannot override** the default channel (chosen by the user who installed your app), username, or icon when you're using Incoming Webhooks to post messages. Instead, these values will always inherit from the associated Slack app configuration.
