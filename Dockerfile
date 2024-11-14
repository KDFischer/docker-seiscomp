
# Docker instance to run seiscomp services in a container

#####################################################################################
# seiscomp base image
#####################################################################################

# build docker image
# docker build --rm --tag kdfischer/seiscomp --target seiscomp .
   
FROM debian:bookworm-slim as seiscomp
LABEL org.opencontainers.image.authors=="Kasper D. Fischer <kasper.fischer@rub.de>"

# install needed packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y \
    libxml2 \
    libboost-filesystem1.74.0 \
    libboost-iostreams1.74.0 \
    libboost-thread1.74.0 \
    libboost-program-options1.74.0 \
    libboost-regex1.74.0 \
    libboost-system1.74.0 \
    libssl3 \
    libncurses5 \
    libmariadb3 \
    libpq5 \
    libpython3.11 \
    python3-numpy \
    libqt5gui5 \
    libqt5xml5 \
    libqt5opengl5 \
    libqt5sql5-sqlite \
    libqt5svg5 \
    libqt5printsupport5
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# create systemuser sysop in group sysop
RUN groupadd -g 1000 sysop && \
    useradd -u 905 -g 1000 -m -s /usr/bin/bash sysop

# add seiscomp to /opt/
ADD --chown=sysop:sysop seiscomp-*-debian-12-x86_64.tar.gz /opt/

# set environment variables
ENV SEISCOMP_ROOT="/opt/seiscomp"
ENV PATH="/opt/seiscomp/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/seiscomp/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH="/opt/seiscomp/lib/python:$PYTHONPATH"
ENV MANPATH="/opt/seiscomp/share/man:$MANPATH"


#####################################################################################
# scheli                                       
#####################################################################################

# Docker instance to run scheli and to
# public created 24h plot on the web
# docker build --rm --tag kdfischer/scheli --target scheli .

FROM seiscomp as scheli
LABEL org.opencontainers.image.authors=="Kasper D. Fischer <kasper.fischer@rub.de>"

# set default user
USER sysop

# copy scheli.sh to /home/sysop/
COPY --chown=sysop:sysop --chmod=755 scheli.sh /home/sysop/
COPY  --chown=sysop:sysop etc/scheli.cfg /opt/seiscomp/etc/scheli.cfg

# set working directory to /home/sysop/
WORKDIR /home/sysop/

# create output and seiscomp log directory
RUN mkdir -p /home/sysop/output
RUN mkdir -p /home/sysop/.seiscomp/log

# set environment variables
ENV QT_QPA_PLATFORM=offscreen

# run scheli.sh as default command
ENTRYPOINT [ "/home/sysop/scheli.sh"]
