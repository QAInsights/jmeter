#!/bin/sh
# Shell script to build multi-architecture JMeter Docker image

set -e  # Exit immediately if a command exits with a non-zero status

# Default values
IMAGE_NAME="jmeter"
IMAGE_TAG="latest"
REGISTRY=""
PLATFORMS="linux/amd64,linux/arm64"
PUSH=false
LOAD=false

# Display help message
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Build multi-architecture Docker images for Apache JMeter"
    echo ""
    echo "Options:"
    echo "  -h, --help                 Show this help message"
    echo "  -n, --name NAME            Set image name (default: jmeter)"
    echo "  -t, --tag TAG              Set image tag (default: latest)"
    echo "  -r, --registry REGISTRY    Set registry (default: none)"
    echo "  -p, --platforms PLATFORMS  Set platforms (default: linux/amd64,linux/arm64)"
    echo "  --push                     Push image to registry"
    echo "  --load                     Load image to local Docker (only works with single platform)"
    echo ""
    echo "Example:"
    echo "  $0 --name jmeter --tag 5.6.3 --registry myregistry.com/ --push"
}

# Parse command line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -n|--name)
            IMAGE_NAME="$2"
            shift 2
            ;;
        -t|--tag)
            IMAGE_TAG="$2"
            shift 2
            ;;
        -r|--registry)
            REGISTRY="$2"
            shift 2
            ;;
        -p|--platforms)
            PLATFORMS="$2"
            shift 2
            ;;
        --push)
            PUSH=true
            shift
            ;;
        --load)
            LOAD=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Set full image name
FULL_IMAGE_NAME="${REGISTRY}${IMAGE_NAME}:${IMAGE_TAG}"

# Check if Docker is installed
if ! command -v docker >/dev/null 2>&1; then
    echo "Error: Docker is not installed or not in PATH"
    exit 1
fi

# Check if Docker BuildX is available
if ! docker buildx version >/dev/null 2>&1; then
    echo "Error: Docker BuildX is not available. Please install it first."
    exit 1
fi

# Create a new builder instance if it doesn't exist
if ! docker buildx inspect multiarch-builder >/dev/null 2>&1; then
    echo "Creating a new BuildX builder instance..."
    docker buildx create --name multiarch-builder --driver docker-container --bootstrap
fi

# Use the builder
docker buildx use multiarch-builder

# Build command construction
BUILD_CMD="docker buildx build --platform ${PLATFORMS} -t ${FULL_IMAGE_NAME}"

# Add push or load flag if specified
if [ "$PUSH" = true ]; then
    BUILD_CMD="${BUILD_CMD} --push"
elif [ "$LOAD" = true ]; then
    # Check if multiple platforms are specified with --load
    if echo "$PLATFORMS" | grep -q ","; then
        echo "Error: --load only works with a single platform. Current platforms: ${PLATFORMS}"
        exit 1
    fi
    BUILD_CMD="${BUILD_CMD} --load"
fi

# Add context
BUILD_CMD="${BUILD_CMD} ."

# Display build information
echo "Building JMeter Docker image with the following configuration:"
echo "  Image name: ${FULL_IMAGE_NAME}"
echo "  Platforms: ${PLATFORMS}"
if [ "$PUSH" = true ]; then
    echo "  Action: Build and push to registry"
elif [ "$LOAD" = true ]; then
    echo "  Action: Build and load to local Docker"
else
    echo "  Action: Build only (no push, no load)"
fi

# Execute the build command
echo "\nExecuting: ${BUILD_CMD}"
eval ${BUILD_CMD}

echo "\nBuild completed successfully!"

# Inspect the image if pushed
if [ "$PUSH" = true ]; then
    echo "\nInspecting the image to verify architectures..."
    docker buildx imagetools inspect "${FULL_IMAGE_NAME}"
fi

echo "\nDone!"
