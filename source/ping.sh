#!/bin/bash

echo "SLACK_TEXT is -$SLACK_TEXT-"

if [[ -z "$SLACK_TEXT" ]]
then
    # If SLACK_TEXT is not set, send the first parameter to the script to Slack
    SLACK_TEXT="$1"
fi

echo "SLACK_TEXT is -$SLACK_TEXT-"

if [[ "$CI_PROJECT_PATH" ]]
then
    SLACK_WEBHOOK_USER="$SLACK_WEBHOOK_USER ($CI_PROJECT_PATH)"
fi

#  Short-circuit evaluate whether SLACK_TEXT exists and has at least length of 10 (bytes)
# https://www.tldp.org/LDP/abs/html/string-manipulation.html
if [[ ! "${SLACK_TEXT}" || "${#SLACK_TEXT}" -le 10 ]]
then
    echo "SLACK_TEXT not present or too short - not sending Slack notification via webhook."
    exit 0
fi

# `trace-ascii -` looks a bit like a typo, but it means to write the trace to STDOUT
curl \
    --trace-ascii - \
    --header "Content-type: application/json" \
   "$SLACK_WEBHOOK_URL" \
    --data-binary @- << EOF
    {
        "text":         "${SLACK_TEXT//\"/\\\"}",
        "attachments":  [$SLACK_ATTACHMENTS],
        "username":     "$SLACK_WEBHOOK_USER",
        "channel":      "$SLACK_WEBHOOK_CHANNEL",
        "icon_url":     "$SLACK_WEBHOOK_ICON"
    }
EOF
