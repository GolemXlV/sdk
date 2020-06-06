FROM ubuntu:20.04
# this is used for testing purposes
WORKDIR /var/gram
ENV DOCKERBUILD=1
COPY ./etc/art /var/gram/etc/art
COPY ./etc/lib /var/gram/etc/lib
COPY ./bin/gram /var/gram/bin/gram
RUN ln -s /var/gram/bin/gram /usr/bin/gram
COPY ./etc/install/init.sh /var/gram/etc/install/init.sh
COPY ./etc/install/nodejs.sh /var/gram/etc/install/nodejs.sh
COPY .nvmrc /var/gram/.nvmrc
RUN gram init
COPY ./etc/install/linux.sh /var/gram/etc/install/linux.sh
RUN gram linux
COPY ./etc/node/compile.sh /var/gram/etc/node/compile.sh
RUN gram compile release_fresh
COPY ./ /var/gram
RUN du /var/gram
RUN gram build-api