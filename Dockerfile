ARG BASEIMAGE=docker/compose:1.24.1
ARG DOCKER_VERSION=docker:latest

FROM $DOCKER_VERSION AS latest_docker

FROM scratch AS yq
ARG YQ_VERSION=2.4.0
ADD "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" /yq


FROM $BASEIMAGE

 # strip out fixed docker-compose entrypoint
ENTRYPOINT []

RUN apk add --no-cache python3 make bash jq fish git

ENV PS1="\h:\w\$ "
CMD bash

RUN pip3 --no-cache install awscli poetry codecov

COPY --from=latest_docker /usr/local/bin/docker /docker
COPY --from=yq /yq /usr/local/bin/yq
