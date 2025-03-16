# 🚀 Lightweight Apache JMeter Docker Image

This repository contains a Dockerfile for a lightweight Apache JMeter image. The Dockerfile is designed to be small and efficient, while still providing the full functionality of Apache JMeter.

## ✨ Features

- Based on the small and secure Alpine Linux image.
- Leverages `bellsoft/liberica-openjdk-alpine` - Liberica JDK is free and 100% open-source Progressive Java Runtime for modern Java deployments. 
- Includes the Apache JMeter for load testing.
- Includes a script for installing JMeter plugins.
- Secured, it will run as `jmeter` - non-root.
- **Multi-architecture support** for both `amd64` (x86_64) and `arm64` platforms.
- Optimized image size using multi-stage builds.

## 🎉 Image Size

- Compressed Size: 165.61 MB
- Uncompressed Size: 264.48 MB

##  🐳 Basic Usage

To build the Docker image, run the following command in the directory containing the Dockerfile:

```bash
docker build -t my-jmeter-image .
```

To run JMeter using the built image, you can use the following command:

```bash
docker run -v /path/to/your/test:/tests my-jmeter-image /tests/your-test.jmx
```
Replace /path/to/your/test with the path to the directory containing your JMeter test, and your-test.jmx with the name of your JMeter test file.

## 🏗️ Multi-Architecture Support

This Docker image supports multiple CPU architectures, allowing it to run on various platforms including:
- x86_64 / AMD64 (standard Intel/AMD processors)
- ARM64 (Apple M1/M2/M3, AWS Graviton, Raspberry Pi 4, etc.)

### Building Multi-Architecture Images

A shell script is provided to build multi-architecture images:

```bash
# Make the script executable
chmod +x build-multiarch.sh

# Show help and available options
./build-multiarch.sh --help

# Build and push multi-architecture image
./build-multiarch.sh --name jmeter --tag 5.6.3 --registry your-registry/ --push
```

The script supports the following options:
- `-h, --help`: Show help message
- `-n, --name NAME`: Set image name (default: jmeter)
- `-t, --tag TAG`: Set image tag (default: latest)
- `-r, --registry REGISTRY`: Set registry (default: none)
- `-p, --platforms PLATFORMS`: Set platforms (default: linux/amd64,linux/arm64)
- `--push`: Push image to registry
- `--load`: Load image to local Docker (only works with single platform)

##  🐳 🐳 Advanced Usage

### 📦 Installing JMeter plugins

In Dockerfile, add the required JMeter plugins to install in a comma separated values as shown below.

```bash
ARG JMETER_PLUGINS="jpgc-udp=0.4,jpgc-dummy"
```

To install specific version add `=` to specify the version, else the latest version will be installed.

### 🔧 Optimizing Image Size

The Dockerfile uses several techniques to minimize the image size:

1. Multi-stage builds to separate build dependencies from runtime
2. Removal of unnecessary files (documentation, Windows batch files)
3. Cleanup of temporary files and package caches
4. Minimal plugin installation

# 💻 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.
