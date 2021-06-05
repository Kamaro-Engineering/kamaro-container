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
RUN DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver "hkp://keyserver.ubuntu.com:80" --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
  && DEBIAN_FRONTEND=noninteractive apt-get update -qy \
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

# This is required for sharing Xauthority
ENV XAUTHORITY=/tmp/.docker.xauth
ENV DISPLAY=:0
ENV QT_X11_NO_MITSHM=1

# Build our robot
COPY fre21_ws /catkin
RUN /catkin/src/cartographer/scripts/install_abseil.sh
RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash && cd /catkin && catkin init && catkin build'

#Mountable location that contains map data for tasks 2/3 and where we expect pred_map.csv to go (in task 2)
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map"]
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/launch"]
VOLUME ["/tmp/.X11-unix"]

# setup the ros master to communicate with the gazebo container. 
ENV ROS_MASTER_URI=http://acontainer:11311

RUN sed -i 's|^\(source .*\)|\1 \&\& source /catkin/devel/setup.bash|g' /ros_entrypoint.sh

CMD sh -c "roslaunch fre21_launch fre21.launch"
