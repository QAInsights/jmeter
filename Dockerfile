FROM bellsoft/liberica-runtime-container:latest

LABEL Author="NaveenKumar Namachivayam"
LABEL Website="https://qainsights.com"
LABEL Description="A Light-weight Apache JMeter Dockerfile based on Alpaquita"

ENV JMETER_VERSION "5.5"
ENV JMETER_HOME "/opt/apache/apache-jmeter-${JMETER_VERSION}"
ENV JMETER_BIN "${JMETER_HOME}/bin"
ENV PATH "$PATH:$JMETER_BIN"
ENV JMETER_CMD_RUNNER_VERSION "2.3"
ENV JMETER_PLUGIN_MANAGER_VERSION "1.8"

COPY entrypoint.sh /entrypoint.sh
COPY jmeter-plugin-install.sh /jmeter-plugin-install.sh
COPY cleanup.sh /cleanup.sh

# Downloading JMeter
RUN wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz -O /tmp/apache-jmeter-${JMETER_VERSION}.tgz && \
    tar -zxvf /tmp/apache-jmeter-${JMETER_VERSION}.tgz && \
    mkdir -p /opt/apache && \
    mv apache-jmeter-${JMETER_VERSION} /opt/apache && \    
    rm /tmp/apache-jmeter-${JMETER_VERSION}.tgz && \
    rm -rf /var/cache/apk/* && \
    chmod a+x /entrypoint.sh && \
    chmod a+x /jmeter-plugin-install.sh && \
    chmod a+x /cleanup.sh

# Downloading CMD Runner
RUN /jmeter-plugin-install.sh

# Cleaning Up
RUN /cleanup.sh

ENTRYPOINT [ "/entrypoint.sh" ]