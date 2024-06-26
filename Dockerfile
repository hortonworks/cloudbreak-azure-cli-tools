FROM mcr.microsoft.com/azure-cli:latest

MAINTAINER Hortonworks

WORKDIR /bin

RUN apk update && apk add bash coreutils jq curl

ADD ./azure-copy /bin/
ADD ./azure-get-latest-vm-image-version /bin/

RUN curl -Lsf https://github.com/hortonworks/pollprogress/releases/download/v1.1/pollprogress_1.1_Linux_x86_64.tgz | tar -xz -C /bin
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/azure/bin

ENTRYPOINT ["/bin/pollprogress"]
