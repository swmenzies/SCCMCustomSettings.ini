# SCCM CustomSettings.ini<br/>
[Notes on informatin provided: XXX = Your Site Code, ### = three digit seqentual number]<br/>
<br/>
In my environment, I relied heavily on the MDT CustomSettings.ini to install software through my SCCM Task Sequences. With the demise of MDT I wanted to carry on the use of a flat file rather than creating collections or adding a long list of applications to the Task Sequence, so I created (very quickly and messily) a script to import the file and build a list of applications to install. <br/>
<br/>
I add a variable near the start of my task sequence, after a Gather.ps1 step. Set Task Sequence Variable -> Variable: XXXCollectionName1, Value: BASE<br/>
At the time of writing, I am currently using Gather.PS1 by Author: Johan Schrewelius, Onevinn AB.<br/>
<br/>
As the Task Sequence runs through its steps, it loads the Task Sequence Variable (XXXCollectionName1=BASE,XXXCollectionName2=DEV) and assigns it in the WinPE environment for later use, You can assign up to five variables.<br/>
<br/>
I created a Run Command Line step and linked it to a package which has the powershell and ini file in it. The Run Command Line code is: *powershell.exe -ExecutionPolicy Bypass -WindowStyle Normal -File "CustomApplicationList.ps1"*<br/>
<br/>
As the script runs, it assigns the variable name Packages###, and assigns the value from the CustomSettings.ini line within the section. It will loop through all lines in each section, for all variables declared, incrementing the package number.<br/>
<br/>
As an example _csutomsettings.ini_ with XXXCollectionName1=BASE & XXXCollectionName2=DEV<br/>
[BASE]<br/>
XXX00109:OSD_ImperoClientInstall<br/>
XXX000E4:OSD_Office2021_Install<br/>
XXX00026:OSD_AdobeReader_Install<br/>
XXX0008D:OSD_VLCSilentInstall<br/>
XXX00039:OSD_ChromeEntInstall<br/>
XXX0009E:OSD_2DDesign_Install<br/>
<br/>
[DEV]<br/>
XXX00071:OSD_VisualStudio<br/>
XXX00072:OSD_VisualStudioCode<br/>
XXX000BA:OSD_SQLStudio<br/>
XXX000D2:OSD_Python_Install<br/>
XXX00101:OSD_NotePadPlusPlusInstall<br/>
<br/>
Assigning the following variables in the TS<br/>
Packages001	XXX00109:OSD_ImperoClientInstall<br/>
Packages002	XXX000E4:OSD_Office2021_Install<br/>
Packages003	XXX00026:OSD_AdobeReader_Install<br/>
Packages004	XXX0008D:OSD_VLCSilentInstall<br/>
Packages005	XXX00039:OSD_ChromeEntInstall<br/>
Packages006	XXX0009E:OSD_2DDesign_Install<br/>
Packages007	XXX00071:OSD_VisualStudio<br/>
Packages008	XXX00072:OSD_VisualStudioCode<br/>
Packages009	XXX000BA:OSD_SQLStudio<br/>
Packages010	XXX000D2:OSD_Python_Install<br/>
Packages011	XXX00101:OSD_NotePadPlusPlusInstall<br/>
<br/>
<br/>
This is working progress, but it is a working script, and I'm sure it can be improved....
