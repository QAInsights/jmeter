#!/bin/sh

# Download CMDRunner jar file
echo "Downloading CMDRunner..."
wget http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/${JMETER_CMD_RUNNER_VERSION}/cmdrunner-${JMETER_CMD_RUNNER_VERSION}.jar -O ${JMETER_HOME}/lib/cmdrunner-${JMETER_CMD_RUNNER_VERSION}.jar

# Download JMeter Plugin Manager jar file
echo "Downloading Plugin Manager..."
wget https://jmeter-plugins.org/get/ -O ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-${JMETER_PLUGIN_MANAGER_VERSION}.jar

# Install the JMeter Plugin Manager
java -cp /opt/apache/apache-jmeter-${JMETER_VERSION}/lib/ext/jmeter-plugins-manager-${JMETER_PLUGIN_MANAGER_VERSION}.jar org.jmeterplugins.repository.PluginManagerCMDInstaller

# Get the input string (a comma-separated list of plugins to install)
input_string="$1"
delimiter=","
IFS="$delimiter" # Set the Internal Field Separator to the delimiter
set -- $input_string # Split the input string into positional parameters

# Iterate over each positional parameter (i.e., each plugin to install)
for item in "$@"; do
    # Install the plugin using the JMeter Plugin Manager
    java -jar ${JMETER_HOME}/lib/cmdrunner-${JMETER_CMD_RUNNER_VERSION}.jar --tool org.jmeterplugins.repository.PluginManagerCMD install $item
done

chmod a+x ${JMETER_HOME}/bin/*.sh