ARG BASE_IMAGE=kamaro:ifort
FROM ${BASE_IMAGE}
ARG user
ARG uid
ARG home

# download and install abaqus
RUN \
      dnf install redhat-lsb curl samba-client -qy && \
      # download and unpack main program
      smbget smb://fast-lt-s01.fast.kit.edu/data-root/Software/Abaqus/2020/2020.AM_SIM_Abaqus_Extend.AllOS.1-4.tar -U lt-fkt-001%lbt_queue_sys -w KIT.EDU -q && \
      smbget smb://fast-lt-s01.fast.kit.edu/data-root/Software/Abaqus/2020/2020.AM_SIM_Abaqus_Extend.AllOS.2-4.tar -U lt-fkt-001%lbt_queue_sys -w KIT.EDU -q && \
      smbget smb://fast-lt-s01.fast.kit.edu/data-root/Software/Abaqus/2020/2020.AM_SIM_Abaqus_Extend.AllOS.3-4.tar -U lt-fkt-001%lbt_queue_sys -w KIT.EDU -q && \
      smbget smb://fast-lt-s01.fast.kit.edu/data-root/Software/Abaqus/2020/2020.AM_SIM_Abaqus_Extend.AllOS.4-4.tar -U lt-fkt-001%lbt_queue_sys -w KIT.EDU -q && \
      ls *.tar | xargs -i tar xf {} 
RUN \
      # download and unpack hotfixes 
      smbget smb://fast-lt-s01.fast.kit.edu/data-root/Software/Abaqus/2020/2020.FP.CFA.2046.Part_SIMULIA_EstPrd.Linux64.tar -U lt-fkt-001%lbt_queue_sys -w KIT.EDU -q && \
      tar -xvf 2020.FP.CFA.2046.Part_SIMULIA_EstPrd.Linux64.tar
RUN \
      # change `lsb_release --short --id |sed 's/ //g'` to "CentOS" in base installation and hotfixes
      sed -i "s/\`lsb_release --short --id |sed 's\/ \/\/g'\`/\"CentOS\"/g" ./AM_SIM_Abaqus_Extend.AllOS/4/SIMULIA_EstablishedProducts/Linux64/1/inst/common/init/Linux.sh && \
      sed -i "s/\`lsb_release --short --id |sed 's\/ \/\/g'\`/\"CentOS\"/g" ./AM_SIM_Abaqus_Extend.AllOS/4/SIMULIA_EstablishedProducts_CAA_API/Linux64/1/inst/common/init/Linux.sh && \
      sed -i "s/\`lsb_release --short --id |sed 's\/ \/\/g'\`/\"CentOS\"/g" ./Part_SIMULIA_EstPrd.Linux64/1/Software/SIMULIA_EstPrd.HF6.Linux64/1/inst/common/init/Linux.sh && \
      sed -i "s/\`lsb_release --short --id |sed 's\/ \/\/g'\`/\"CentOS\"/g" ./Part_SIMULIA_EstPrd.Linux64/1/Software/CAASIMULIA_EstPrd.HF6.Linux64/1/inst/common/init/Linux.sh 
      # config file for 'silent' base installation
COPY --chown=${uid}:${uid} UserIntentions_CODE.xml "/UserIntentions_CODE.xml"
      
COPY --chown=${uid}:${uid} UserIntentions_CAA.xml "/UserIntentions_CAA.xml"

RUN \
      cd AM_SIM_Abaqus_Extend.AllOS/4/ && \
      # CODE base installation
      ./SIMULIA_EstablishedProducts/Linux64/1/StartTUI.sh --silent /UserIntentions_CODE.xml && \
      # CAA base installation
      ./SIMULIA_EstablishedProducts_CAA_API/Linux64/1/StartTUI.sh --silent /UserIntentions_CAA.xml && \
      cd ../../
RUN \
      # remove archives and installation files
      rm /2020* -rf && \
      rm /AM_SIM_Abaqus_Extend.AllOS -rf

RUN \
      cd ./Part_SIMULIA_EstPrd.Linux64/1/Software/ && \
      # CODE install hotfixes
      ./SIMULIA_EstPrd.HF6.Linux64/1/StartTUI.sh --silent /UserIntentions_CODE.xml && \
      # CAA install hotfixes
      ./CAASIMULIA_EstPrd.HF6.Linux64/1/StartTUI.sh --silent /UserIntentions_CAA.xml && \
      cd ../../../
RUN \
      # remove archives, installation files and config files
      rm /Part_SIMULIA_EstPrd.Linux64 -rf && \
      rm /2020.FP.CFA.2046.Part_SIMULIA_EstPrd.Linux64.tar -f && \
      rm /UserIntentions_CAA.xml /UserIntentions_CODE.xml
RUN \
      # setup license
      mkdir -p /var/DassaultSystemes/Licenses/ && \
      echo 'scclic5.scc.kit.edu:4085' > /var/DassaultSystemes/Licenses/DSLicSrv.txt && \
      # symlink abaqus to abq2020
      ln /var/DassaultSystemes/SIMULIA/Commands/abq2020hf6 /usr/bin/abaqus

RUN \ 
      # install old dependency for pip
      curl -O https://download.copr.fedorainfracloud.org/results/dioni21/compat-openssl10/fedora-35-x86_64/02529460-compat-openssl10/compat-openssl10-1.0.2o-11.fc35.x86_64.rpm && \
      dnf localinstall compat-openssl10-1.0.2o-11.fc35.x86_64.rpm -qy && \
      dnf install git-all -qy &&\
      # set permissions for pip 
      chmod 777 -R /usr/SIMULIA/EstProducts/2020/linux_a64/tools/SMApy/python2.7/bin && \
      chmod 777 -R /usr/SIMULIA/EstProducts/2020/linux_a64/tools/SMApy/python2.7/lib/python2.7/site-packages  && \
      chmod 777 -R /var/DassaultSystemes/SIMULIA/CAE/plugins

# Clone user into docker image
RUN \
  echo "${user}:x:${uid}:${uid}:${user},,,:${home}:/bin/bash" >> /etc/passwd && \
  echo "${user}:*:18572:0:99999:7:::" >> /etc/shadow && \
  echo "${user}:x:${uid}:" >> /etc/group && \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
  chmod 0440 "/etc/sudoers.d/${user}" && \
  mkdir -p "${home}" && chown "${user}:${user}" "${home}"

RUN \
      # test installation
      abaqus information=version

# Switch to user
USER "${user}"
WORKDIR "${home}"
ENV USER "${user}"

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

CMD ["/bin/bash", "-i"]
