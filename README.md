# Lightweight Apache JMeter Docker Image

This repository contains a Dockerfile for a lightweight Apache JMeter image. The Dockerfile is designed to be small and efficient, while still providing the full functionality of Apache JMeter.

## Features

- Based on the small and secure Alpine Linux image.
- Includes the Apache JMeter for load testing.
- Includes a script for installing JMeter plugins.
- Secured, it will run as `jmeter` - non-root.

## Image Size

- Compressed Size: 165.61 MB
- Uncompressed Size: 264.48 MB

## Basic Usage

To build the Docker image, run the following command in the directory containing the Dockerfile:

```bash
docker build -t my-jmeter-image .
```

To run JMeter using the built image, you can use the following command:

```bash
docker run -v /path/to/your/test:/tests my-jmeter-image /tests/your-test.jmx
```
Replace /path/to/your/test with the path to the directory containing your JMeter test, and your-test.jmx with the name of your JMeter test file.

## Advanced Usage

### Installing JMeter plugins

In Dockerfile, add the required JMeter plugins to install in a comma separated values as shown below.

```bash
ARG JMETER_PLUGINS="jpgc-udp=0.4,jpgc-dummy"
```

To install specific version add `=` to specify the version, else the latest version will be installed.

# Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

