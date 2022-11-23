ARG BASE_IMAGE=kitware/paraview:pv-v5.8.0-osmesa-py3
FROM ${BASE_IMAGE}

USER root

RUN apt-get -y update  && apt-get -y install git python python-pip python3.8
RUN python3.8 -m pip install -U pip