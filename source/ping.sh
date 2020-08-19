#!/bin/bash

#debug verbosity
readonly LOG_LEVEL_NONE=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_WARN=5
readonly LOG_LEVEL_DEBUG=10
readonly LOG_LEVEL_TRACE=100


[[ -n "$DEBUG_LEVEL" && "$DEBUG_LEVEL" -ge "$LOG_LEVEL_INFO" ]] && echo -e "SLACK_TEXT from ENV is\r\n\t$SLACK_TEXT"

if [[ -z "$SLACK_TEXT" ]]
then
    # If SLACK_TEXT is not set, send the first parameter to the script to Slack
    SLACK_TEXT="$1"
fi

[[ -n "$DEBUG_LEVEL" && "$DEBUG_LEVEL" -ge "$LOG_LEVEL_INFO" ]] && echo -e "SLACK_TEXT to send is\r\n\t$SLACK_TEXT"

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

curl_options=()
curl_options+=( "$SLACK_WEBHOOK_URL" )
curl_options+=( --header "Content-type: application/json" )

# `trace-ascii -` looks a bit like a typo, but it means to write the trace to STDOUT
[[ -n "$DEBUG_LEVEL" && "$DEBUG_LEVEL" -ge "$LOG_LEVEL_TRACE" ]] && curl_options+=( --trace-ascii - )

curl "${curl_options[@]}" \
    --data-binary @- << EOF
    {
        "text":         "${SLACK_TEXT//\"/\\\"}",
        "attachments":  [$SLACK_ATTACHMENTS],
        "username":     "$SLACK_WEBHOOK_USER",
        "channel":      "$SLACK_WEBHOOK_CHANNEL",
        "icon_url":     "$SLACK_WEBHOOK_ICON"
    }
EOF
