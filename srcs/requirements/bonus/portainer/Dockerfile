FROM alpine:3.21

RUN apk-add --no-cache ca-certificates

# download  and install portainer

ARG PORTAINER_VERSION=2.33.2
ARG TARGETARCH="amd64"

RUN wget "https://github.com/portainer/portainer/releases/download/2.33.2/portainer-2.33.2-linux-amd64.tar.gz"
portainer

