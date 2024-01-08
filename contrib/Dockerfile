FROM amd64/ubuntu:20.04 AS base

#If you found this docker image helpful please donate MEWC to the maintainer
LABEL maintainer="RV9zdNeUTQUToZUcRp9uNF8gwH5LzDFtan"

EXPOSE 8766/tcp
EXPOSE 8788/tcp

ENV DEBIAN_FRONTEND=noninteractive

#Install runtime dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	bash wget net-tools libminiupnpc17 \
	libevent-2.1 libevent-pthreads-2.1 \
	libboost-system1.71 libboost-filesystem1.71 libboost-chrono1.71 \
	libboost-program-options1.71 libboost-thread1.71 \
	libzmq5 && \
	apt-get clean

FROM base AS build

#Install build dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	bash net-tools build-essential libtool autotools-dev automake \
	pkg-config libssl-dev libevent-dev bsdmainutils python3 \
	libboost-system1.71-dev libboost-filesystem1.71-dev libboost-chrono1.71-dev \
	libboost-program-options1.71-dev libboost-test1.71-dev libboost-thread1.71-dev \
	libzmq3-dev libminiupnpc-dev && \
	apt-get clean

#Copy source dir
COPY . /home/meow/build/Meowcoin/
WORKDIR /home/meow/build/Meowcoin

#build db4 from source
WORKDIR /home/meow/build/Meowcoin/contrib
RUN ./install_db4.sh ../../

# build Meowcore
WORKDIR /home/meow/build/Meowcoin
RUN ./autogen.sh && ./configure --disable-tests BDB_LIBS="-L/home/meow/build/db4/lib -ldb_cxx-4.8" BDB_CFLAGS="-I/home/meow/build/db4/include" --with-gui=no  && make -j4

FROM base AS final

#Add our service account user
RUN useradd -ms /bin/bash meow && \
	mkdir /var/lib/meow && \
	chown meow:meow /var/lib/meow && \
	ln -s /var/lib/meow /home/meow/.meow && \
	chown -h meow:meow /home/meow/.meow

VOLUME /var/lib/meow

#Copy the compiled binaries from the build
COPY --from=build /home/meow/build/Meowcoin/src/meowd /usr/local/bin/meowd
COPY --from=build /home/meow/build/Meowcoin/src/meow-cli /usr/local/bin/meow-cli

WORKDIR /home/meow
USER meow

CMD /usr/local/bin/meowd -datadir=/var/lib/meow -printtoconsole -onlynet=ipv4
