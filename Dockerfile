FROM azuresdk/azure-cli-python:latest

MAINTAINER Hortonworks

WORKDIR /bin

RUN apk update && apk add bash coreutils jq curl

ADD ./azure-copy /bin/

RUN curl -Lsf https://github.com/hortonworks/pollprogress/releases/download/v0.1.3/pollprogress_0.1.3_Linux_x86_64.tgz | tar -xz -C /bin
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/azure/bin

ENTRYPOINT ["/bin/pollprogress"]
