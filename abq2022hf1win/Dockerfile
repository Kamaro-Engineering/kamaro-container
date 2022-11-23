# escape=`

# Base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

RUN `
      # Download base Abaqus
      curl `
            -O ftp://ftp.scc.kit.edu/pub/campus/ABAQUS/SIMULIA_2022/2022.AM_SIM_Abaqus_Extend.AllOS.1-5.tar `
            -O ftp://ftp.scc.kit.edu/pub/campus/ABAQUS/SIMULIA_2022/2022.AM_SIM_Abaqus_Extend.AllOS.2-5.tar `
            -O ftp://ftp.scc.kit.edu/pub/campus/ABAQUS/SIMULIA_2022/2022.AM_SIM_Abaqus_Extend.AllOS.3-5.tar `
            -O ftp://ftp.scc.kit.edu/pub/campus/ABAQUS/SIMULIA_2022/2022.AM_SIM_Abaqus_Extend.AllOS.4-5.tar `
            -O ftp://ftp.scc.kit.edu/pub/campus/ABAQUS/SIMULIA_2022/2022.AM_SIM_Abaqus_Extend.AllOS.5-5.tar

RUN  `
      # Unpack base files
      tar xf 2022.AM_SIM_Abaqus_Extend.AllOS.1-5.tar && `
      tar xf 2022.AM_SIM_Abaqus_Extend.AllOS.2-5.tar && `
      tar xf 2022.AM_SIM_Abaqus_Extend.AllOS.3-5.tar && `
      tar xf 2022.AM_SIM_Abaqus_Extend.AllOS.4-5.tar && `
      tar xf 2022.AM_SIM_Abaqus_Extend.AllOS.5-5.tar && `
      del *.tar

RUN ` 
      # Download and unpack hotfixes 
      curl -O http://ftp.scc.kit.edu/pub/campus/ABAQUS/SIMULIA_2022/updates/2022.FP.CFA.2205.Part_SIMULIA_EstPrd.Windows64.zip && `
      powershell -command "Expand-Archive 2022.FP.CFA.2205.Part_SIMULIA_EstPrd.Windows64.zip"  && `
      del *.zip

# Copy user intentions
COPY UserIntentions_CODE.xml "UserIntentions_CODE.xml"
COPY UserIntentions_CAA.xml "UserIntentions_CAA.xml"

RUN `
      # CODE base installation
      AM_SIM_Abaqus_Extend.AllOS\2\SIMULIA_EstablishedProducts\Windows64\1\StartTUI.exe --silent UserIntentions_CODE.xml && `
      # CAA base installation
      AM_SIM_Abaqus_Extend.AllOS\3\SIMULIA_EstablishedProducts_CAA_API\Windows64\1\StartTUI.exe --silent UserIntentions_CAA.xml 

RUN `
      # CODE hotfix installation
      2022.FP.CFA.2205.Part_SIMULIA_EstPrd.Windows64\Part_SIMULIA_EstPrd.Windows64\1\Software\SIMULIA_EstPrd.HF1.Windows64\1\StartTUI.exe --silent UserIntentions_CODE.xml && `
      # CAA hotfix installation
      2022.FP.CFA.2205.Part_SIMULIA_EstPrd.Windows64\Part_SIMULIA_EstPrd.Windows64\1\Software\CAASIMULIA_EstPrd.HF1.Windows64\1\StartTUI.exe --silent UserIntentions_CAA.xml

# Cleanup
RUN ` 
      powershell -command "Remove-Item AM_SIM_Abaqus_Extend.AllOS -Recurse -Force" && ` 
      powershell -command "Remove-Item 2022.FP.CFA.2205.Part_SIMULIA_EstPrd.Windows64 -Recurse -Force"

RUN `
      # Add commands to PATH and test installation
      setx /M path "%path%;C:\SIMULIA\Commands" && `
      setx /M PYTHONIOENCODING UTF-8  && `
      abaqus information=version

# Install Chocolatey
RUN powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
RUN setx PATH "%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

# Install git
RUN choco install git.install -y