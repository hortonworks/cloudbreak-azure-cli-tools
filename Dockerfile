FROM gliderlabs/alpine:3.2

MAINTAINER Hortonworks

ADD ./deploy_dash /bin/
WORKDIR /bin

RUN apk update && apk add bash coreutils git jq nodejs

RUN git clone https://github.com/sequenceiq/azure-xplat-cli.git /azure 
RUN cd /azure && git checkout release-0.9.8
RUN cd /azure && npm install

ENTRYPOINT ["/bin/deploy_dash"]
