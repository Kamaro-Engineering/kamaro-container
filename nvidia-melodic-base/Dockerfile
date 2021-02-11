ARG BASE_IMAGE=nvidia/cudagl:10.0-devel-ubuntu18.04
FROM ${BASE_IMAGE}

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get upgrade -qy

#install melodic
RUN \
  echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list \
  && apt-key adv --keyserver "hkp://keyserver.ubuntu.com:80" --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
  && DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy ros-melodic-ros-base

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    build-essential \
    python-catkin-tools \
    python-pip \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    python3-pip \
    python3-vcstool \
  && rosdep init
