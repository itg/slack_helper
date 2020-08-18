# slack_helper
A Docker image to streamline sending a message to Slack

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

## Usage Note: Mutliple In, Single Out

If you provide both `SLACK_TEXT` and a message parameter, only the `SLACK_TEXT` value is used

For example, this command will send "message foo" to Slack:
```
docker run --rm --env SLACK_TEXT="message foo" midmich/slack_helper:latest "message bar"
```

## Run-Time Configuration

### Required Enviroment variables

* `SLACK_WEBHOOK_URL`

### Optional Envronment variables
* `SLACK_TEXT`
* `SLACK_WEBHOOK_CHANNEL`
* `SLACK_WEBHOOK_USER`
* `SLACK_WEBHOOK_ICON`

The `SLACK_WEBHOOK_*` variables are typically stored somewhere (e.g. in Gitlab CI/CD configuration variables) and usually do not need to be explicitly specified in `.env` or `docker-compose.yml`.
