FROM    bash:latest
LABEL   maintainer="Mid Michigan College Programming Team <programming@midmich.edu>" \
        description="An image for easily putting a message to Slack via a webhook"

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]

# Supply default Environment variables available to, and can be overridden in,
#   containers built from this image
ENV     SLACK_WEBHOOK_CHANNEL="#testing" \
        SLACK_WEBHOOK_ICON="https://gitlab.com/gitlab-com/gitlab-artwork/raw/master/logo/logo-square.png" \
        SLACK_WEBHOOK_URL="" \
        SLACK_WEBHOOK_USER="Webhook Message"

RUN 	apk add --update --no-cache \
            bash \
            curl \
            tzdata \
        && cp /usr/share/zoneinfo/America/Detroit /etc/localtime \
        && echo "America/Detroit" > /etc/timezone

COPY    source/     /source
RUN     ln -sf /source/ping.sh  /entrypoint.sh

# Make it easy to find the time the container was built by putting it everywhere
ARG     BUILD_TIME

LABEL   org.opencontainers.image.created="$BUILD_TIME"

RUN     echo "$BUILD_TIME" > /BUILD_TIME \
        && ln -sf /BUILD_TIME /BUILD_DATE
