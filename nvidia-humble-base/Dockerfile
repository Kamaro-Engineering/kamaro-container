ARG BASE_IMAGE=kamaro/cudagl:11.8.0-devel-ubuntu22.04
FROM ${BASE_IMAGE}

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get upgrade -qy

#install dependencies for ros install
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    curl software-properties-common locales \
  && locale-gen en_US en_US.UTF-8 \
  && update-locale LC_ALL=en_US LANG=en_US.UTF-8 \
  && add-apt-repository universe

#install noetic
RUN \
  curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" > /etc/apt/sources.list.d/ros2.list \
  && DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    ros-humble-ros-base \
    ros-dev-tools \
    python3-colcon-common-extensions \
    python3-rosdep

# Mirror behavior of official ros containers:
ENV ROS_DISTRO humble

RUN rosdep init && rosdep update --rosdistro $ROS_DISTRO

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
