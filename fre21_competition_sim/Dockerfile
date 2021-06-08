ARG BASE_IMAGE=ros:melodic-ros-base-bionic
FROM ${BASE_IMAGE}

# Based on:
# https://github.com/FieldRobotEvent/Virtual_Field_Robot_Event/competition_environment/a_container/Dockerfile

#Competition dependencies
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
  DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -qy install ros-${ROS_DISTRO}-desktop-full ros-${ROS_DISTRO}-pointgrey-camera-description && \
  DEBIAN_FRONTEND=noninteractive apt-get -qy install ros-${ROS_DISTRO}-robot-localization ros-${ROS_DISTRO}-twist-mux && \
  DEBIAN_FRONTEND=noninteractive apt-get -qy install ros-${ROS_DISTRO}-interactive-marker-twist-server ros-${ROS_DISTRO}-hector-gazebo-plugins && \
  DEBIAN_FRONTEND=noninteractive apt-get -qy install git python3-jinja2 python3-rospkg python3-opencv python3-matplotlib python3-shapely  && \
  DEBIAN_FRONTEND=noninteractive apt-get -qy install git screen  && \
  rm -rf /var/lib/apt/lists/*

#Plain gazebo requirements
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
  DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -qy install ros-${ROS_DISTRO}-gazebo-ros-pkgs && \
  DEBIAN_FRONTEND=noninteractive apt-get -qy install ros-${ROS_DISTRO}-gazebo-ros-control && \
  rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
  DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -qy install ros-${ROS_DISTRO}-urdfdom-py

#Make the code required for the container and add it to the entrypoint
RUN mkdir -p /catkin/src && cd /catkin/src && git clone https://github.com/FieldRobotEvent/Virtual_Field_Robot_Event.git && rm -rf Virtual_Field_Robot_Event/example_robot
RUN bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash && cd /catkin && catkin_make"
RUN sed -i 's|^\(source .*\)|\1 \&\& source /catkin/devel/setup.bash|g' /ros_entrypoint.sh

#Map volume location
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map"]
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/Media"]
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/worlds"]
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/launch"]
VOLUME ["/catkin/src/my_robot"]
VOLUME ["/tmp/.X11-unix"]
VOLUME ["/tmp/.docker.xauth"]

EXPOSE 8080 11345

ENV XAUTHORITY=/tmp/.docker.xauth
ENV DISPLAY=:0
ENV QT_X11_NO_MITSHM=1

# Launch the simulation
# task 1 and 2
CMD sh -c "roslaunch virtual_maize_field jackal_simulation.launch paused:=true"
