FROM phusion/baseimage:0.9.17
MAINTAINER AltSol <info@altsol.gr>

# upgrade operating system
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# install dependencies
RUN apt-get -y install unzip openjdk-7-jre-headless

# install rexster
ADD http://tinkerpop.com/downloads/rexster/rexster-server-2.6.0.zip /
RUN unzip rexster-server-2.6.0.zip
RUN rm rexster-server-2.6.0.zip
RUN mv rexster-server-2.6.0 rexster-server

# install neo4j2 dependencies
RUN mkdir -p /rexster-server/lib/neo4j1
RUN mkdir -p /rexster-server/ext/lib
RUN mv /rexster-server/lib/neo4j-* /rexster-server/lib/neo4j1
COPY neo4j2-ext/target/dependency/* /rexster-server/ext/lib/
RUN mv /rexster-server/ext/lib/blueprints-neo4j2-graph-*.jar /rexster-server/ext/

# install custom rexster config file
COPY rexster-neo4j2.xml /rexster-server/config/

# install rexster service
RUN mkdir /etc/service/rexster
ADD rexster.sh /etc/service/rexster/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /rexster-server
EXPOSE 8182 8183 8184
VOLUME ["/var/log/rexster", "/rexster-server/data/neo4j2graph"]
# Use baseimage-docker's init system as entrypoint
CMD ["/sbin/my_init"]
