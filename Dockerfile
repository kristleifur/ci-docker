ARG BASEIMAGE=docker/compose:1.24.1
ARG DOCKER_VERSION=docker:latest


FROM $DOCKER_VERSION AS latest_docker
# 'latest_docker' is used as a `COPY --from` target at the end

# download some dependencies as dedicated build stages so buildkit can parallelize them
FROM $BASEIMAGE AS yq
ARG YQ_VERSION=2.4.0
RUN wget "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -O /yq
RUN chmod +x yq

FROM $BASEIMAGE AS pup
ARG PUP_VERSION=0.4.0
RUN wget -O- "https://github.com/ericchiang/pup/releases/download/v${PUP_VERSION}/pup_v${PUP_VERSION}_linux_amd64.zip" \
    | busybox unzip -  # writes binary to /pup
RUN chmod +x /pup


FROM $BASEIMAGE as ci-docker

 # strip out fixed docker-compose entrypoint
ENTRYPOINT []

RUN apk add --no-cache python3 make bash jq fish git curl

ENV PS1="\h:\w\$ "
CMD bash

RUN pip3 --no-cache install awscli poetry codecov

COPY --from=latest_docker /usr/local/bin/docker /docker
COPY --from=yq /yq /usr/local/bin/yq
COPY --from=pup /pup /usr/local/bin/pup
