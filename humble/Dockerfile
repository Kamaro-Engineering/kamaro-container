ARG BASE_IMAGE=osrf/ros:humble-desktop
FROM ${BASE_IMAGE}

#basic utilities
RUN DEBIAN_FRONTEND=noninteractive apt update -qy \
  && DEBIAN_FRONTEND=noninteractive apt install -qy \
  apt-transport-https \
  bash-completion \
  ca-certificates \
  curl \
  gdb \
  git \
  git-lfs \
  ripgrep \
  gnupg \
  software-properties-common \
  ssh \
  sudo \
  tmux \
  nano \
  neovim \
  wget

# install rest of ROS humble
RUN DEBIAN_FRONTEND=noninteractive apt update -qy \
  && DEBIAN_FRONTEND=noninteractive apt install -qy ros-humble-desktop

# common ros tools
RUN DEBIAN_FRONTEND=noninteractive apt update -qy \
  && DEBIAN_FRONTEND=noninteractive apt install -qy \
  build-essential \
  python3-osrf-pycommon \
  python3-pip \
  python3-colcon-common-extensions \
  python3-vcstool \
  python3-wstool

# simulation
RUN DEBIAN_FRONTEND=noninteractive apt update -qy \
  && DEBIAN_FRONTEND=noninteractive apt install -qy \
  ignition-fortress \
  ros-humble-ros-ign-bridge \
  ros-humble-xacro

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
# arm
RUN DEBIAN_FRONTEND=noninteractive apt update -qy \
  && DEBIAN_FRONTEND=noninteractive apt install -qy \
  ros-humble-moveit \
  ros-humble-ros-testing \
  ros-humble-ros2test \
  ros-humble-ros2-control \
  ros-humble-ros2-control-test-assets \
  ros-humble-ros2-controllers \
  ros-humble-ros2controlcli \
  ros-humble-gazebo-ros2-control \
  ros-humble-hardware-interface \
  ros-humble-transmission-interface \
  ros-humble-controller-interface \
  ros-humble-controller-manager \
  ros-humble-controller-manager-msgs \
  ros-humble-forward-command-controller \
  ros-humble-position-controllers \
  ros-humble-joint-limits \
  ros-humble-joint-state-broadcaster \
  ros-humble-joint-trajectory-controller \
  ros-humble-joint-state-publisher \
  ros-humble-joint-state-publisher-gui \
  ros-humble-rviz-visual-tools \
  ros-humble-control-toolbox \
  ros-humble-robot-localization \
  python3-pygraphviz \ 
  ros-humble-realtime-tools \
  ros-humble-graph-msgs \
  ros-humble-ament-clang-format 

# RUN sudo -H pip3 install -U onnxruntime onnx

# Switch to user
USER "${user}"
WORKDIR "${home}"

RUN rosdep update

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

CMD ["/bin/bash", "-i"]
