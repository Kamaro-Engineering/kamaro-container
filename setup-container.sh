#!/bin/bash
set -e
basedir="$(dirname "$0")"

if [[ "$(whoami)" != 'root' ]] && ! [ "$(groups | grep -F 'docker')" ]; then
  echo 'Must be either in group "docker" or be run with sudo'
  exit 1
fi

#TODO allow custom container name (Usage setup-container.sh [-i image_name] [container_name])
#FIXME check for existence of image and non-existence of container

image_name="kamaro:melodic"
container_name="melodic-container"

additional_args=""
if glxinfo | grep -iq "vendor.*nvidia"; then
  echo "Detected nvidia gpu. Make sure nvidia-container-toolkit is installed: https://github.com/NVIDIA/nvidia-docker"
  additional_args+=" --gpus all "
fi

if [ "$SUDO_USER" ]; then
  _home="/home/$SUDO_USER"
else
  _home="$HOME"
fi

# workspaces
workspace_args=""
source "$basedir/workspaces"
for workspace_info in "${WORKSPACES[@]}"; do
  set -- $workspace_info
  ws_dir=$1
  ws_dir="${ws_dir/#\~/$_home}"
  echo "$ws_dir"
  if ! [ -d "$ws_dir" ]; then
    echo "Workspace '$ws_dir' configured in $basedir/workspaces does not exist"
    exit 1
  fi
  workspace_args+=" -v $ws_dir:$ws_dir "
done
if [ -z "$workspace_args" ]; then
  echo "No workspaces are configured in $basedir/workspaces"
  exit 1
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

docker container cp "$basedir/workspaces" "$container_name:$_home/.workspaces"
