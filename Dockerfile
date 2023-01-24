FROM bellsoft/liberica-runtime-container:latest

LABEL Author="NaveenKumar Namachivayam"
LABEL Website="https://qainsights.com"
LABEL Description="A Light-weight Apache JMeter Dockerfile based on Alpaquita"

ENV JMETER_VERSION="5.5"
ENV JMETER_CMD_RUNNER_VERSION="2.3"
ENV JMETER_PLUGIN_MANAGER_VERSION="1.8"
ENV JMETER_HOME="/opt/apache/apache-jmeter-${JMETER_VERSION}"

RUN wget -q https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz -O /tmp/apache-jmeter-${JMETER_VERSION}.tgz \
    && mkdir -p /opt/apache \
    && tar -zxvf /tmp/apache-jmeter-${JMETER_VERSION}.tgz -C /opt/apache \
    && rm /tmp/apache-jmeter-${JMETER_VERSION}.tgz

ENV JMETER_BIN="${JMETER_HOME}/bin"
ENV PATH="$PATH:$JMETER_BIN"

COPY entrypoint.sh /entrypoint.sh
COPY jmeter-plugin-install.sh /jmeter-plugin-install.sh
COPY cleanup.sh /cleanup.sh

RUN chmod +x /entrypoint.sh \
    && chmod +x /jmeter-plugin-install.sh \
    && chmod +x /cleanup.sh \
    && /jmeter-plugin-install.sh \
    && /cleanup.sh

ENTRYPOINT ["/entrypoint.sh"]
