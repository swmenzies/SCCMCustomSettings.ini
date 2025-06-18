# SCCM CustomSettings.ini
[Notes on informatin provided: XXX = Your Site Code, ### = three digit seqentual number]

In my environment, I relied heavily on the MDT CustomSettings.ini to install software through my SCCM Task Sequences. With the demise of MDT I wanted to carry on the use of a flat file rather than creating collections or adding a long list of applications to the Task Sequence, so I created (very quickly and messily) a script to import the file and build a list of applications to install. 

I add a variable near the start of my task sequence, after a Gather.ps1 step. Set Task Sequence Variable -> Variable: XXXCollectionName1, Value: BASE
At the time of writing, I am currently using Gather.PS1 by Author: Johan Schrewelius, Onevinn AB.

As the Task Sequence runs through its steps, it loads the Task Sequence Variable (XXXCollectionName1=BASE,XXXCollectionName2=DEV) and assigns it in the WinPE environment for later use, You can assign up to five variables.

I created a Run Command Line step and linked it to a package which has the powershell and ini file in it. The Run Command Line code is: *powershell.exe -ExecutionPolicy Bypass -WindowStyle Normal -File "CustomApplicationList.ps1"*

As the script runs, it assigns the variable name Packages###, and assigns the value from the CustomSettings.ini line within the section. It will loop through all lines in each section, for all variables declared, incrementing the package number.

As an example _csutomsettings.ini_ with XXXCollectionName1=BASE & XXXCollectionName2=DEV
[BASE]
XXX00109:OSD_ImperoClientInstall
XXX000E4:OSD_Office2021_Install
XXX00026:OSD_AdobeReader_Install
XXX0008D:OSD_VLCSilentInstall
XXX00039:OSD_ChromeEntInstall
XXX0009E:OSD_2DDesign_Install

[DEV]
XXX00071:OSD_VisualStudio
XXX00072:OSD_VisualStudioCode
XXX000BA:OSD_SQLStudio
XXX000D2:OSD_Python_Install
XXX00101:OSD_NotePadPlusPlusInstall

Assigning the following variables in the TS
Packages001	XXX00109:OSD_ImperoClientInstall
Packages002	XXX000E4:OSD_Office2021_Install
Packages003	XXX00026:OSD_AdobeReader_Install
Packages004	XXX0008D:OSD_VLCSilentInstall
Packages005	XXX00039:OSD_ChromeEntInstall
Packages006	XXX0009E:OSD_2DDesign_Install
Packages007	XXX00071:OSD_VisualStudio
Packages008	XXX00072:OSD_VisualStudioCode
Packages009	XXX000BA:OSD_SQLStudio
Packages010	XXX000D2:OSD_Python_Install
Packages011	XXX00101:OSD_NotePadPlusPlusInstall
