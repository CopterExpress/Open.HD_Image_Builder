FROM ubuntu:18.04

RUN apt-get update \
	&& apt-get install -y --no-install-recommends unzip curl git qemu qemu-user-static binfmt-support build-essential gcc-arm* parted wget ca-certificates bc sudo xz-utils dosfstools \
	&& apt-get clean

WORKDIR /root

CMD /bin/bash

