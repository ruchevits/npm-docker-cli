#!/usr/bin/env bash

get_abs_filename() {
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

get_docker_image_name() {
  PACKAGE_NAME=$(grep '"name":' $1 | cut -d\" -f4 | cut -c 2-)
  PACKAGE_VERSION=$(grep '"version":' $1 | cut -d\" -f4)
  echo "$PACKAGE_NAME:$PACKAGE_VERSION"
}

PROGRAM_NAME=$(basename $0)

PACKAGE_FILE="package.json"
PACKAGE_FILE_PATH=$(get_abs_filename $PACKAGE_FILE)

# Check if package.json file exists at given location
if [ ! -f "$PACKAGE_FILE_PATH" ]
then
  echo "File package.json does not exist at: $PACKAGE_FILE_PATH"
  exit 1
fi

# Read package name version
DOCKER_IMAGE_NAME=$(get_docker_image_name $PACKAGE_FILE)

sub_help(){
    echo "Usage: $PROGRAM_NAME <subcommand> [options]"
    echo "Subcommands:"
    echo "    build      Build docker image based on name and version from the package.json file"
    echo "    deploy     Deploy docker image to a specified repository on EC2 container service"
}

sub_build() {

  DOCKER_FILE="Dockerfile"
  DOCKER_FILE_PATH=$(get_abs_filename $DOCKER_FILE)

  # Check if Docker file exists at given location
  if [ ! -f "$DOCKER_FILE_PATH" ]
  then
    echo "Dockerfile does not exist at: $DOCKER_FILE_PATH"
    exit 1
  fi

  echo "Building docker image: $DOCKER_IMAGE_NAME"

  # TODO: Build docker image
  # docker build -t $DOCKER_IMAGE_NAME $DOCKER_FILE
  echo "Error: not implemented"
  exit 1

}

sub_deploy() {

  DEPLOYMENT_FILE="deployment.json"
  DEPLOYMENT_FILE_PATH=$(get_abs_filename $DEPLOYMENT_FILE)

  # Check if Docker file exists at given location
  if [ ! -f "$DEPLOYMENT_FILE_PATH" ]
  then
    echo "File deployment.json does not exist at: $DEPLOYMENT_FILE_PATH"
    exit 1
  fi

  echo "Deploying docker image: $DOCKER_IMAGE_NAME"

  # TODO: deploy container
  echo "Error: not implemented"
  exit 1

}

SUB_COMMAND=$1

case $SUB_COMMAND in
    "" | "-h" | "--help")
        sub_help
        ;;
    *)
        shift
        sub_${SUB_COMMAND} $@
        if [ $? = 127 ]; then
            echo "Error: '$SUB_COMMAND' is not a known sub command." >&2
            echo "Run '$PROGRAM_NAME --help' for a list of known sub commands." >&2
            exit 1
        fi
        ;;
esac
