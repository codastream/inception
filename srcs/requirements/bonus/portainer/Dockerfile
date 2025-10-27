FROM alpine:3.21

RUN apk add --no-cache ca-certificates curl apache2-utils

ARG PORTAINER_VERSION=2.33.2
ARG TARGETARCH="amd64"

RUN mkdir -p /tmp/portainer && cd /tmp/portainer \
    && wget "https://github.com/portainer/portainer/releases/download/${PORTAINER_VERSION}/portainer-${PORTAINER_VERSION}-linux-${TARGETARCH}.tar.gz" \
    && tar xvzf "portainer-${PORTAINER_VERSION}-linux-${TARGETARCH}.tar.gz"

RUN ls -la /tmp/portainer

RUN mv /tmp/portainer/portainer /usr/local/bin/

RUN chmod +x /usr/local/bin/portainer \
    && cd / && rm -rf /tmp/portainer

COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]

# CMD ["/usr/local/bin/portainer/portainer", "--data", "/data"]

