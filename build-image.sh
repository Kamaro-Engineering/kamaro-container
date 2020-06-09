#!/usr/bin/bash
set -e
basedir="$(dirname "$0")"

if [[ "$(whoami)" != 'root' ]] && ! [ "$(groups | grep -F 'docker')" ]; then
  echo 'Must be either in group "docker" or be run with sudo'
  exit 1
fi
if [[ "$(whoami)" == 'root' ]] && [ -z "$SUDO_USER" ]; then
  echo "Cannot be root! Use sudo or add user to the docker group"
  exit 1
fi

#TODO allow custom image name (Usage: build-image.sh [-c <custom-config>] [image_name])

_custom_config="$1"
if [ "$_custom_config" ]; then
  if ! [ -f "$_custom_config/Dockerfile" ] || \
       [ "$_custom_config" -ef "$basedir/melodic" ] || \
       [ "$_custom_config" -ef "$basedir/nvidia" ]; then
    echo "$_custom_config is not a docker build directory for a custom config"
    exit 1
  fi
fi

pushd .

image_name="kamaro:melodic"

base_image_args="" #empty uses default
if [ "$SUDO_USER" ]; then
  _user="$SUDO_USER"
  _uid="$SUDO_UID"
  _home="/home/$SUDO_USER"
else
  _user="$USER"
  _uid="$UID"
  _home="$HOME"
fi

if glxinfo | grep -iq "vendor.*nvidia"; then
  echo "$(tput setaf 3)Building from nvidias base image.
Requires nvidia-container-toolkit: https://github.com/NVIDIA/nvidia-docker$(tput sgr0)"
  cd "$basedir/nvidia"
  docker build \
    --network=host \
    -t "$image_name" .
  base_image_args="--build-arg BASE_IMAGE=$image_name"
fi

popd
pushd .

cd "$basedir/melodic"
docker build \
  $base_image_args \
  --build-arg user=$_user \
  --build-arg uid=$_uid \
  --build-arg home=$_home \
  --network=host \
  -t "$image_name" .

popd
pushd .

if [ "$_custom_config" ]; then
  cd "$_custom_config"
  docker build \
    --build-arg "BASE_IMAGE=$image_name" \
    --build-arg uid=$_uid \
    --network=host \
    -t "$image_name" .
fi

popd
