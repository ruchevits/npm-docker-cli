#!/usr/bin/env bash

NPM_REGISTRY_TOKEN="JSXGUN/1pN5nNr/EDzWSBK3h4h3jOB0Un5GT4I84bRU="

get_abs_filename() {
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

get_docker_image_name() {
  PACKAGE_NAME=$(node -p -e "require('./package.json').name.substr(1)")
  echo "$PACKAGE_NAME"
}

get_docker_image_version() {
  PACKAGE_VERSION=$(node -p -e "require('./package.json').version")
  echo "$PACKAGE_VERSION"
}

get_aws_repository_url() {
  REPOSITORY_URL=$(node -p -e "require('./package.json').deployment.repository")
  echo "$REPOSITORY_URL"
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

# Read package name and version
DOCKER_IMAGE_NAME=$(get_docker_image_name $PACKAGE_FILE)
DOCKER_IMAGE_VERSION=$(get_docker_image_version $PACKAGE_FILE)

# Truncate 'tallysticks/' from the docker image name
DOCKER_CONTAINER_NAME=$(echo $DOCKER_IMAGE_NAME | cut -c 13-)

sub_help(){
    echo "Usage: $PROGRAM_NAME <subcommand> [options]"
    echo "Subcommands:"
    echo "    help       Display this information"
    echo "    build      Build docker image based on name and version from the package.json file"
    # echo "    create     Create new docker container based on the built image"
    echo "    deploy     Deploy docker image to a specified repository on EC2 container service"
    echo "    run        Run docker container"
    # echo "    stop       Stop running container"
    # echo "    restart    Restart running container"
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

  echo "Building docker image: $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION"

  # Build docker image
  docker build \
    --no-cache \
    --build-arg NPM_REGISTRY_TOKEN=$NPM_REGISTRY_TOKEN \
    -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION \
    -f $DOCKER_FILE .

}

# sub_create() {
#   # docker create --name $DOCKER_CONTAINER_NAME $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION
# }

sub_deploy() {

  AWS_REPOSITORY_URL=$(get_aws_repository_url $PACKAGE_FILE)

  echo "Deploying docker image: $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION to $AWS_REPOSITORY_URL"

  echo "sda"

  # docker tag $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION $AWS_REPOSITORY_URL:$DOCKER_IMAGE_VERSION
  # docker push $AWS_REPOSITORY_URL:$DOCKER_IMAGE_VERSION

}

sub_run() {

  docker run -d --name $DOCKER_CONTAINER_NAME $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION

  # TODO: save returned container ID (e.g. 59cfbc659bf7f17488c9a6c327e85a4945376fb4405a3037d0c9b0dbb69ea045)
  # TODO: 

}

# sub_stop() {
#   # TODO: stop container using the container ID saved in sub_run()
# }

# sub_restart() {
#   # TODO: restart container using the container ID saved in sub_run()
# }

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
