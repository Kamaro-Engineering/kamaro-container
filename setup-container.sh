#!/bin/bash
set -e
basedir="$(dirname "$0")"

usage_info="Usage: $0 [-n <container_name>] [-c <ws-config>] <image_name>

Creates a new development container from the image <image_name>.
If <container_name> is not specified, the container will have the same name as the tag
of the image its based on, otherwise <container_name>.

<ws-config> should be a sourceable bash file configuring workspaces in an associative
array like in $basedir/workspaces. Defaults to $basedir/workspaces.
"

if [[ "$(whoami)" != 'root' ]] && ! [ "$(groups | grep -F 'docker')" ]; then
  echo 'Must be either in group "docker" or be run with sudo'
  exit 1
fi

container_name=""
ws_config="$basedir/workspaces"
while getopts hn:c: opt; do
  case $opt in
    n)
      container_name="$OPTARG"
      ;;
    c)
      ws_config="$OPTARG"
      ;;
    ?)
      echo "$usage_info"
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))
image_name="$1"

if [ -z "$image_name" ]; then
  echo "No image_name given!"
  echo "$usage_info"
  exit 1
fi
if [ -z "$container_name" ]; then
  container_name="${image_name#*:}"
fi
if ! source "$ws_config"; then
  echo "Config file '$ws_config' is not a sourceable bash file"
  exit 1
fi
if ! declare -p WORKSPACES | grep -qE '^declare.*-A.*WORKSPACES=.*'; then
  echo "Config file '$ws_config' does not declare an associative array WORKSPACES"
  exit 1
fi

if docker inspect "$container_name" &> /dev/null; then
  echo "There already exists a container named '$container_name'!"
  echo "Either specify a different name or remove the old container with:"
  echo "  ${SUDO_USER:+sudo }docker container rm '$container_name'"
  exit 1
fi

if ! docker inspect "$image_name" &> /dev/null; then
  echo "There exists no docker image '$image_name'. List images with:"
  echo "  ${SUDO_USER:+sudo }docker images"
  echo
  echo "(Hint: the full name of an image is <REPOSITORY>:<TAG>)"
  exit 1
fi

if [ "$SUDO_USER" ]; then
  _home="/home/$SUDO_USER"
else
  _home="$HOME"
fi

workspace_args=""
source "$ws_config"
for workspace_info in "${WORKSPACES[@]}"; do
  set -- $workspace_info
  ws_dir="${1/#\~/$_home}" # expand tilde
  if ! [ -d "$ws_dir" ]; then
    echo "Workspace '$ws_dir' configured in $ws_config does not exist."
    exit 1
  fi
  workspace_args+=" -v $ws_dir:$ws_dir "
done
if [ -z "$workspace_args" ]; then
  echo "No workspaces are configured in $ws_config"
  exit 1
fi

additional_args=""
if glxinfo | grep -iq "vendor.*nvidia"; then
  additional_args+=" --gpus all "
fi

docker container create \
  $additional_args \
  -e DISPLAY \
  -v '/tmp/.X11-unix:/tmp/.X11-unix:ro' \
  -v "$_home/.ssh:$_home/.ssh:ro" \
  $workspace_args \
  --network=host \
  --name "$container_name" \
  -it "$image_name"

docker container cp "$ws_config" "$container_name:$_home/.workspaces"

echo "$(tput setaf 2)Created development container $container_name.$(tput sgr0)
You can start the container with:
  ${SUDO_USER:+sudo }docker start $container_name
  ${SUDO_USER:+sudo }docker exec -it $container_name bash -i

Or use the accompanying script $basedir/con:
  ${SUDO_USER:+sudo }con $container_name"
