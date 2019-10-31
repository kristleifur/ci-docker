ARG BASEIMAGE=python:3.7-slim-buster
ARG DOCKER_VERSION=docker:latest
ARG DOCKER_COMPOSE_DEBIAN_IMAGE=docker/compose:1.25.0-rc4-debian
ARG DOCKER_COMPOSE_ALPINE_IMAGE=docker/compose:1.25.0-rc4-alpine

# these are used as a `COPY --from` target at the end
FROM $DOCKER_VERSION AS docker_image
FROM $DOCKER_COMPOSE_DEBIAN_IMAGE AS docker_compose_image

# download some dependencies as dedicated build stages so buildkit can parallelize them
FROM $DOCKER_COMPOSE_ALPINE_IMAGE AS yq
ARG YQ_VERSION=2.4.0
RUN wget "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -O /yq
RUN chmod +x yq

FROM $DOCKER_COMPOSE_ALPINE_IMAGE AS pup
ARG PUP_VERSION=0.4.0
RUN wget -O- "https://github.com/ericchiang/pup/releases/download/v${PUP_VERSION}/pup_v${PUP_VERSION}_linux_amd64.zip" \
    | busybox unzip -  # writes binary to /pup
RUN chmod +x /pup


FROM $BASEIMAGE as ci-docker

CMD bash

RUN apt-get update \
 && apt-get install -y --no-install-recommends gcc make curl wget jq git

RUN pip install --no-cache awscli poetry codecov

COPY --from=docker_image /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker_compose_image /usr/local/bin/docker-compose /usr/local/bin/docker-compose
COPY --from=yq /yq /usr/local/bin/yq
COPY --from=pup /pup /usr/local/bin/pup
