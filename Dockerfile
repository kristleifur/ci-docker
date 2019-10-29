ARG BASEIMAGE=docker/compose:1.24.1
FROM $BASEIMAGE as baseimage

ENV PS1="\h:\w\$ "

FROM baseimage
RUN apk add --no-cache python3 make bash jq fish
RUN pip3 --no-cache install awscli poetry codecov

ARG YAML_BIN_VERSION=2.4.0
RUN wget -O /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/download/${YAML_BIN_VERSION}/yq_linux_amd64"

ENTRYPOINT []
CMD bash
