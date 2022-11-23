# escape=`

# Base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# download and install abaqus
RUN `
      # download and unpack main program
      net use s: \\fast-lt-s01.fast.kit.edu\data-root\Software /user:kit.edu\lt-fkt-001 lbt_queue_sys && `
      copy S:\Abaqus\2020\2020.AM_SIM_Abaqus_Extend.AllOS.1-4.tar 2020.AM_SIM_Abaqus_Extend.AllOS.1-4.tar && `
      copy S:\Abaqus\2020\2020.AM_SIM_Abaqus_Extend.AllOS.2-4.tar 2020.AM_SIM_Abaqus_Extend.AllOS.2-4.tar && `
      copy S:\Abaqus\2020\2020.AM_SIM_Abaqus_Extend.AllOS.3-4.tar 2020.AM_SIM_Abaqus_Extend.AllOS.3-4.tar && `
      copy S:\Abaqus\2020\2020.AM_SIM_Abaqus_Extend.AllOS.4-4.tar 2020.AM_SIM_Abaqus_Extend.AllOS.4-4.tar

RUN  `
      # Unpack base files
      tar xf 2020.AM_SIM_Abaqus_Extend.AllOS.1-4.tar && `
      tar xf 2020.AM_SIM_Abaqus_Extend.AllOS.2-4.tar && `
      tar xf 2020.AM_SIM_Abaqus_Extend.AllOS.3-4.tar && `
      tar xf 2020.AM_SIM_Abaqus_Extend.AllOS.4-4.tar && `
      del *.tar

RUN `
      # download and unpack hotfixes 
      net use s: \\fast-lt-s01.fast.kit.edu\data-root\Software /user:kit.edu\lt-fkt-001 lbt_queue_sys && `
      copy S:\Abaqus\2020\2020.FP.CFA.2046.Part_SIMULIA_EstPrd.Windows64.zip 2020.FP.CFA.2046.Part_SIMULIA_EstPrd.Windows64.zip && `
      powershell -command "Expand-Archive 2020.FP.CFA.2046.Part_SIMULIA_EstPrd.Windows64.zip"  && `
      del *.zip


# Copy user intentions
COPY UserIntentions_CODE.xml "UserIntentions_CODE.xml"
COPY UserIntentions_CAA.xml "UserIntentions_CAA.xml"

RUN `
      # CODE base installation
      AM_SIM_Abaqus_Extend.AllOS\2\SIMULIA_EstablishedProducts\Windows64\1\StartTUI.exe --silent UserIntentions_CODE.xml && `
      # CAA base installation
      AM_SIM_Abaqus_Extend.AllOS\2\SIMULIA_EstablishedProducts_CAA_API\Windows64\1\StartTUI.exe --silent UserIntentions_CAA.xml 

RUN `
      # CODE hotfix installation
      2020.FP.CFA.2046.Part_SIMULIA_EstPrd.Windows64\Part_SIMULIA_EstPrd.Windows64\1\Software\SIMULIA_EstPrd.HF6.Windows64\1\StartTUI.exe --silent UserIntentions_CODE.xml && `
      # CAA hotfix installation
      2020.FP.CFA.2046.Part_SIMULIA_EstPrd.Windows64\Part_SIMULIA_EstPrd.Windows64\1\Software\CAASIMULIA_EstPrd.HF6.Windows64\1\StartTUI.exe --silent UserIntentions_CAA.xml

# Cleanup
RUN ` 
      powershell -command "Remove-Item AM_SIM_Abaqus_Extend.AllOS -Recurse -Force" && ` 
      powershell -command "Remove-Item 2020.FP.CFA.2046.Part_SIMULIA_EstPrd.Windows64 -Recurse -Force"

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