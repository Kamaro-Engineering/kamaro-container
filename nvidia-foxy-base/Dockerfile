ARG BASE_IMAGE=nvidia/cudagl:11.2.0-devel-ubuntu20.04
FROM ${BASE_IMAGE}

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get upgrade -qy

#install dependencies for ros install
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    curl gnupg2 locales \
  && locale-gen en_US en_US.UTF-8 \
  && update-locale LC_ALL=en_US LANG=en_US.UTF-8

#install noetic
RUN \
  echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-noetic.list \
  && apt-key adv --keyserver "hkp://keyserver.ubuntu.com:80" --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
  && DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    ros-noetic-ros-base \
    python3-rosdep

RUN rosdep init
