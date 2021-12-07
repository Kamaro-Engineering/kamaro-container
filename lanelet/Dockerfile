ARG BASE_IMAGE=ros:noetic-ros-base-focal
FROM ${BASE_IMAGE}

#basic utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    apt-transport-https \
    bash-completion \
    ca-certificates \
    curl \
    gdb \
    git \
    gnupg \
    nano \
    software-properties-common \
    ssh \
    sudo \
    tmux \
    neovim \
    wget

#install rest of ROS noetic
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy ros-noetic-desktop-full

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    build-essential \
    python3-catkin-tools \
    python3-osrf-pycommon \
    python3-pip \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-vcstool \
    python3-wstool

ARG user
ARG uid
ARG home

# Clone user into docker image
RUN \
  echo "${user}:x:${uid}:${uid}:${user},,,:${home}:/bin/bash" >> /etc/passwd && \
  echo "${user}:*:18572:0:99999:7:::" >> /etc/shadow && \
  echo "${user}:x:${uid}:" >> /etc/group && \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
  chmod 0440 "/etc/sudoers.d/${user}" && \
  mkdir -p "${home}" && chown "${user}:${user}" "${home}"

#basic config
COPY --chown=${uid}:${uid} bashrc "${home}/.bashrc"
COPY --chown=${uid}:${uid} bash_profile "${home}/.bash_profile"

# semantic_scene_graph and lanelet dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    libceres-dev \
    libgflags-dev \
    libgmock-dev \
    libgoogle-glog-dev \
    libignition-common3-dev \
    libignition-common3-graphics-dev \
    liblua5.2-dev \
    libopencv-apps-dev \
    ninja-build \
    python3-catkin \
    python3-pygame \
    python3-pydot \
    stow \
    libboost-dev \
    ros-noetic-mrt-cmake-modules \
    libeigen3-dev \ 
    libgeographic-dev \
    libpugixml-dev \
    libpython3-dev \
    libboost-python-dev \
    ros-noetic-rospack \
    ros-noetic-catkin

# compile lanelet2 from source
RUN \
      source /opt/ros/noetic/setup.bash \
      mkdir -p ./lanelet_ws/src \
      cd ./lanelet_ws \
      catkin init \
      catkin config --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      git clone https://github.com/fzi-forschungszentrum-informatik/lanelet2.git ./src \
      catkin build \
      source ./devel/setup.bash

# Switch to user
USER "${user}"
WORKDIR "${home}"

RUN rosdep update

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

CMD ["/bin/bash", "-i"]
