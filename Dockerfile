FROM ubuntu:16.04
MAINTAINER David ‘Bombe’ Roden <bombe@freenetproject.org>
LABEL "description"="Minimal container to allow running Freenet."

EXPOSE 8888 9481

# Install curl and Java
RUN apt-get update && \
    apt-get install -y curl

# Install Java
ENV JAVA_VERSION_MAJOR=8 JAVA_VERSION_MINOR=74 JAVA_VERSION_BUILD=02 JAVA_PACKAGE=jre
RUN curl -jkSLH "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | tar -xzf - -C /opt && \
    ln -s /opt/${JAVA_PACKAGE}1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/java

# Download Freenet & dependencies
WORKDIR /usr/lib/freenet
RUN curl "https://downloads.freenetproject.org/alpha/freenet-build01470.jar" > freenet.jar && \
    curl "https://downloads.freenetproject.org/alpha/freenet-ext.jar" > freenet-ext.jar && \
    curl "http://downloads.bouncycastle.org/java/bcprov-jdk15on-152.jar" > bcprov.jar

# Set up environment
ENV JAVA_HOME="/opt/java" PATH="${PATH}:${JAVA_HOME}/bin"

# Set up node directory
WORKDIR /usr/lib/freenet/node
RUN curl "https://downloads.freenetproject.org/alpha/opennet/seednodes.fref" > seednodes.fref

# Create basic usable configuration file
COPY freenet.ini .

# Start the node
CMD ["java", "-cp", "../bcprov.jar:../freenet-ext.jar:../freenet.jar", "freenet.node.NodeStarter"]
