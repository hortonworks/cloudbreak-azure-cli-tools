FROM gliderlabs/alpine:3.2

MAINTAINER Hortonworks

WORKDIR /bin

RUN apk update && apk add bash coreutils git jq nodejs

RUN git clone -b v0.10.9-February2017 https://github.com/Azure/azure-xplat-cli.git /azure \
    && rm -rf /azure/test

RUN cd /azure && npm install

ADD ./cli_tools /bin/
ADD ./azure-copy /bin/

RUN curl -L https://github.com/hortonworks/pollprogress/releases/download/v0.1.0/pollprogress_0.1.0_Linux_x86_64.tgz | tar -xz -C /bin
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/azure/bin

ENTRYPOINT ["/bin/cli_tools"]
