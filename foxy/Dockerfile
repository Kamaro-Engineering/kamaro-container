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

#install foxy
RUN \
  echo "deb http://packages.ros.org/ros2/ubuntu focal main" > /etc/apt/sources.list.d/ros2-foxy.list \
  && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
  && DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy ros-foxy-ros-base

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

#for getting dependencies run: rosdep install -s -r -i --from-paths src/
# virtualfre noetic dependencies
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
    python3-jinja2 \
    python3-matplotlib \
    python3-opencv \
    python3-osrf-pycommon \
    python3-pygame \
    python3-rospkg \
    python3-shapely \
    ros-noetic-amcl \
    ros-noetic-gmapping \
    ros-noetic-hector-gazebo \
    ros-noetic-hector-gazebo-plugins \
    ros-noetic-hector-trajectory-server \
    ros-noetic-interactive-marker-twist-server \
    ros-noetic-interactive-markers \
    ros-noetic-joy \
    ros-noetic-map-server \
    ros-noetic-move-base \
    ros-noetic-moveit-msgs \
    ros-noetic-pcl-conversions \
    ros-noetic-pointgrey-camera-description \
    ros-noetic-robot-localization \
    ros-noetic-rosdoc-lite \
    ros-noetic-teleop-twist-joy \
    ros-noetic-twist-mux \
    stow

# virtualfre foxy dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    ros-foxy-nav2-bringup \
    ros-foxy-navigation2 \
    ros-foxy-ros1-bridge

# Switch to user
USER "${user}"
WORKDIR "${home}"

RUN rosdep update

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

CMD ["/bin/bash", "-i"]
