FROM gliderlabs/alpine:3.2

MAINTAINER Hortonworks

WORKDIR /bin

RUN apk update && apk add bash coreutils git jq nodejs

RUN git clone https://github.com/sequenceiq/azure-xplat-cli.git /azure \
    && rm -rf /azure/test

RUN cd /azure && git checkout release-0.9.8
RUN cd /azure && npm install

ADD ./cli_tools /bin/
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/azure/bin

ENTRYPOINT ["/bin/cli_tools"]
