ARG BASE_IMAGE=kamaro:ifort
FROM ${BASE_IMAGE}
ARG user
ARG uid
ARG home

# download and install abaqus
RUN \
      dnf install redhat-lsb curl -qy && \
      # download and unpack main program
      curl \
        -O ftp://ftp.scc.kit.edu/pub/campus/ABAQUS/SIMULIA_2022/2022.AM_SIM_Abaqus_Extend.AllOS.1-5.tar \
        -O ftp://ftp.scc.kit.edu/pub/campus/ABAQUS/SIMULIA_2022/2022.AM_SIM_Abaqus_Extend.AllOS.2-5.tar \
        -O ftp://ftp.scc.kit.edu/pub/campus/ABAQUS/SIMULIA_2022/2022.AM_SIM_Abaqus_Extend.AllOS.3-5.tar \
        -O ftp://ftp.scc.kit.edu/pub/campus/ABAQUS/SIMULIA_2022/2022.AM_SIM_Abaqus_Extend.AllOS.4-5.tar \
        -O ftp://ftp.scc.kit.edu/pub/campus/ABAQUS/SIMULIA_2022/2022.AM_SIM_Abaqus_Extend.AllOS.5-5.tar && \
      ls *.tar | xargs -i tar xf {} 
RUN \
      # download and unpack hotfixes 
      curl -O http://ftp.scc.kit.edu/pub/campus/ABAQUS/SIMULIA_2022/updates/2022.FP.CFA.2250.Part_SIMULIA_EstPrd.Linux64.tar && \
      tar -xvf 2022.FP.CFA.2250.Part_SIMULIA_EstPrd.Linux64.tar
RUN \
      # change `lsb_release --short --id |sed 's/ //g'` to "CentOS" in base installation and hotfixes
      sed -i "s/\`lsb_release --short --id |sed 's\/ \/\/g'\`/\"CentOS\"/g" ./AM_SIM_Abaqus_Extend.AllOS/4/SIMULIA_EstablishedProducts/Linux64/1/inst/common/init/Linux.sh && \
      sed -i "s/\`lsb_release --short --id |sed 's\/ \/\/g'\`/\"CentOS\"/g" ./AM_SIM_Abaqus_Extend.AllOS/5/SIMULIA_EstablishedProducts_CAA_API/Linux64/1/inst/common/init/Linux.sh && \
      sed -i "s/\`lsb_release --short --id |sed 's\/ \/\/g'\`/\"CentOS\"/g" ./Part_SIMULIA_EstPrd.Linux64/1/Software/SIMULIA_EstPrd.HF1.Linux64/1/inst/common/init/Linux.sh && \
      sed -i "s/\`lsb_release --short --id |sed 's\/ \/\/g'\`/\"CentOS\"/g" ./Part_SIMULIA_EstPrd.Linux64/1/Software/CAASIMULIA_EstPrd.HF1.Linux64/1/inst/common/init/Linux.sh 

      # config file for 'silent' base installation
COPY --chown=${uid}:${uid} UserIntentions_CODE.xml "/UserIntentions_CODE.xml"
      
COPY --chown=${uid}:${uid} UserIntentions_CAA.xml "/UserIntentions_CAA.xml"

RUN \
      # CODE base installation
      ./AM_SIM_Abaqus_Extend.AllOS/4/SIMULIA_EstablishedProducts/Linux64/1/StartTUI.sh --silent /UserIntentions_CODE.xml && \
      # CAA base installation
      ./AM_SIM_Abaqus_Extend.AllOS/5/SIMULIA_EstablishedProducts_CAA_API/Linux64/1/StartTUI.sh --silent /UserIntentions_CAA.xml
RUN \
      # remove archives and installation files
      rm /2022* -rf && \
      rm /AM_SIM_Abaqus_Extend.AllOS -rf

RUN \
      cd ./Part_SIMULIA_EstPrd.Linux64/1/Software/ && \
      # CODE install hotfixes
      ./SIMULIA_EstPrd.HF1.Linux64/1/StartTUI.sh --silent /UserIntentions_CODE.xml && \
      # CAA install hotfixes
      ./CAASIMULIA_EstPrd.HF1.Linux64/1/StartTUI.sh --silent /UserIntentions_CAA.xml && \
      cd ../../../
RUN \
      # remove archives, installation files and config files
      rm /Part_SIMULIA_EstPrd.Linux64 -rf && \
      rm /2022.FP.CFA.2205.Part_SIMULIA_EstPrd.Linux64.tar -f && \
      rm /UserIntentions_CAA.xml /UserIntentions_CODE.xml
RUN \
      # setup license
      mkdir -p /var/DassaultSystemes/Licenses/ && \
      echo 'scclic5.scc.kit.edu:4085' > /var/DassaultSystemes/Licenses/DSLicSrv.txt && \
      # symlink abaqus to abq2022
      ln /var/DassaultSystemes/SIMULIA/Commands/abq2022hf1 /usr/bin/abaqus

RUN \ 
      # install old dependency for pip
      curl -O https://download.copr.fedorainfracloud.org/results/dioni21/compat-openssl10/fedora-35-x86_64/02529460-compat-openssl10/compat-openssl10-1.0.2o-11.fc35.x86_64.rpm && \
      dnf localinstall compat-openssl10-1.0.2o-11.fc35.x86_64.rpm -qy && \
      dnf install git-all -qy &&\
      # set permissions for pip 
      chmod 777 -R /usr/SIMULIA/EstProducts/2022/linux_a64/tools/SMApy/python2.7/bin && \
      chmod 777 -R /usr/SIMULIA/EstProducts/2022/linux_a64/tools/SMApy/python2.7/lib/python2.7/site-packages && \
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
