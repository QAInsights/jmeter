# Global ARG for JMeter version that can be used across all build stages
ARG JMETER_VERSION="5.6.3"

# Use bellsoft/liberica-openjdk-alpine as the base image for the build stage
# This base image supports multiple architectures including amd64 and arm64
FROM bellsoft/liberica-openjdk-alpine:11.0.21-10 AS builder

# Redeclare the ARG in the builder stage to make it accessible
ARG JMETER_VERSION

# Set build arguments for cmdrunner version, and plugin manager version
ARG JMETER_CMD_RUNNER_VERSION="2.3"
ARG JMETER_PLUGIN_MANAGER_VERSION="1.9"

# Set build argument for JMeter plugins to be installed
ARG JMETER_PLUGINS="jpgc-udp=0.4"

# Set environment variable for JMeter home directory
ENV JMETER_HOME="/opt/apache/apache-jmeter-${JMETER_VERSION}"

# Download JMeter, extract it to /opt/apache, and remove the downloaded tarball
RUN wget -q https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz -O /tmp/apache-jmeter-${JMETER_VERSION}.tgz \
    && mkdir -p /opt/apache \
    && tar -zxvf /tmp/apache-jmeter-${JMETER_VERSION}.tgz -C /opt/apache \
    && rm /tmp/apache-jmeter-${JMETER_VERSION}.tgz

# Set environment variables for JMeter bin directory
ENV JMETER_BIN="${JMETER_HOME}/bin"

# Copy shell scripts from the host to the image
COPY jmeter-plugin-install.sh /jmeter-plugin-install.sh
COPY cleanup.sh /cleanup.sh

# Make the shell scripts executable, install JMeter plugins, and clean up
RUN chmod +x /jmeter-plugin-install.sh /cleanup.sh \
    && /jmeter-plugin-install.sh ${JMETER_PLUGINS} \
    && /cleanup.sh \
    # Remove unnecessary files to reduce image size
    && rm -rf ${JMETER_HOME}/bin/*.bat \
    && rm -rf ${JMETER_HOME}/bin/*.cmd \
    && rm -rf ${JMETER_HOME}/docs \
    && rm -rf ${JMETER_HOME}/printable_docs \
    # Remove temporary files and caches
    && rm -rf /tmp/* /var/cache/apk/*

# Start with a clean Alpine base for the final image
# This base image supports multiple architectures including amd64 and arm64
FROM bellsoft/liberica-openjdk-alpine:11.0.21-10

# Redeclare the ARG in the final stage to make it accessible
ARG JMETER_VERSION

# Set metadata for the image
LABEL Author="NaveenKumar Namachivayam"
LABEL Website="https://qainsights.com"
LABEL Description="A Light-weight Apache JMeter Dockerfile based on Alpaquita"
LABEL org.opencontainers.image.description="Multi-architecture Apache JMeter Docker image"
LABEL org.opencontainers.image.source="https://github.com/QAInsights/jmeter"

# Set environment variable for JMeter home directory
ENV JMETER_HOME="/opt/apache/apache-jmeter-${JMETER_VERSION}"
ENV JMETER_BIN="${JMETER_HOME}/bin"
ENV PATH="$PATH:$JMETER_BIN"

# Copy only the necessary JMeter files from the builder stage
COPY --from=builder ${JMETER_HOME} ${JMETER_HOME}

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the working directory to /jmeter
WORKDIR /jmeter

# Create a new user 'jmeter' and change ownership of /jmeter to 'jmeter'
RUN adduser -D jmeter \
    && chown -R jmeter:jmeter /jmeter

# Switch to 'jmeter' user
USER jmeter

# Set the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]