# Use bellsoft/liberica-openjdk-alpine:11.0.21-10 as the base image
FROM bellsoft/liberica-openjdk-alpine:11.0.21-10

# Set metadata for the image
LABEL Author="NaveenKumar Namachivayam"
LABEL Website="https://qainsights.com"
LABEL Description="A Light-weight Apache JMeter Dockerfile based on Alpaquita"

# Set build arguments for JMeter version, cmdrunner version, and plugin manager version
ARG JMETER_VERSION="5.6.2"
ARG JMETER_CMD_RUNNER_VERSION="2.3"
ARG JMETER_PLUGIN_MANAGER_VERSION="1.9"

# Set build argument for JMeter plugins to be installed
ARG JMETER_PLUGINS="jpgc-udp=0.4"

# Switch to root user to perform installation
USER root

# Set environment variable for JMeter home directory
ENV JMETER_HOME="/opt/apache/apache-jmeter-${JMETER_VERSION}"

# Download JMeter, extract it to /opt/apache, and remove the downloaded tarball
RUN wget -q https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz -O /tmp/apache-jmeter-${JMETER_VERSION}.tgz \
    && mkdir -p /opt/apache \
    && tar -zxvf /tmp/apache-jmeter-${JMETER_VERSION}.tgz -C /opt/apache \
    && rm /tmp/apache-jmeter-${JMETER_VERSION}.tgz

# Set environment variables for JMeter bin directory and PATH
ENV JMETER_BIN="${JMETER_HOME}/bin"
ENV PATH="$PATH:$JMETER_BIN"

# Copy shell scripts from the host to the image
COPY entrypoint.sh /entrypoint.sh
COPY jmeter-plugin-install.sh /jmeter-plugin-install.sh
COPY cleanup.sh /cleanup.sh

# Make the shell scripts executable, install JMeter plugins, and clean up
RUN chmod +x /entrypoint.sh /jmeter-plugin-install.sh /cleanup.sh \
    && /jmeter-plugin-install.sh ${JMETER_PLUGINS} \
    && /cleanup.sh

# Set the working directory to /jmeter
WORKDIR /jmeter

# Create a new user 'jmeter' and change ownership of /jmeter to 'jmeter'
RUN adduser -D jmeter \
    && chown -R jmeter:jmeter /jmeter

# Switch to 'jmeter' user
USER jmeter

# Set the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]