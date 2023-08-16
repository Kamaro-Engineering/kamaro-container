ARG BASE_IMAGE=fedora:35
FROM ${BASE_IMAGE}

#system upgrade
RUN dnf upgrade -qy 

#install dependencies for intel fortran install
RUN dnf install gcc python findutils procps -qy

#download and install intel parallel studio
RUN \
      curl ftp://ftp.scc.kit.edu/pub/campus/INTEL/parallel_studio_xe_2016_composer_edition_for_fortran_update4.tgz -O && \
      tar -xzvf parallel_studio_xe_2016_composer_edition_for_fortran_update4.tgz 

ARG uid
COPY --chown=${uid}:${uid} silent.cfg "/parallel_studio_xe_2016_composer_edition_for_fortran_update4/silent.cfg" 

RUN \
      cd parallel_studio_xe_2016_composer_edition_for_fortran_update4 && \
      ./install.sh -s silent.cfg 
RUN \
      echo "source /opt/intel/bin/compilervars.sh intel64" > /etc/profile.d/custom.sh
RUN \
      # remove archives and installation files
      rm /parallel_studio_xe_2016_composer_edition_for_fortran_update4* -rf && \
      source /opt/intel/bin/compilervars.sh intel64 && \
      ifort -v
