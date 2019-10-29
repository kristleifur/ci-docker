ARG BASEIMAGE=docker/compose:1.24.1
FROM $BASEIMAGE as baseimage

ENTRYPOINT []

RUN apk add --no-cache python3 make bash jq fish git

RUN mv $(which docker) $(which docker).old \
 && echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories \
 && apk add docker-cli

ENV PS1="\h:\w\$ "
CMD bash

ARG YQ_BIN_VERSION=2.4.0
RUN wget -O /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/download/${YQ_BIN_VERSION}/yq_linux_amd64"

RUN pip3 --no-cache install awscli poetry codecov
