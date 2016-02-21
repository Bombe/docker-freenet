FROM ubuntu:16.04
MAINTAINER David ‘Bombe’ Roden <bombe@freenetproject.org>
LABEL "description"="Minimal container to allow running Freenet."

EXPOSE 8888 9481

# Install curl and Java
RUN apt-get update && \
    apt-get install -y curl openjdk-8-jre-headless

# Download Freenet & dependencies
ENV FREENET_DIR /usr/share/freenet
WORKDIR ${FREENET_DIR}
RUN curl "https://downloads.freenetproject.org/alpha/freenet-build01470.jar" > freenet.jar && \
    curl "https://downloads.freenetproject.org/alpha/freenet-ext.jar" > freenet-ext.jar && \
    curl "http://downloads.bouncycastle.org/java/bcprov-jdk15on-152.jar" > bcprov.jar

# Set up node directory
WORKDIR /var/lib/freenet
RUN curl "https://downloads.freenetproject.org/alpha/opennet/seednodes.fref" > seednodes.fref

# Create basic usable configuration file
COPY freenet.ini .

# Start the node
CMD java -cp ${FREENET_DIR}/bcprov.jar:${FREENET_DIR}/freenet-ext.jar:${FREENET_DIR}/freenet.jar freenet.node.NodeStarter
