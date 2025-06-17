# SCCM CustomSettings.ini
In my environment, I relied heavily on the MDT CustomSettings.ini to install software. With the demise of MDT I wanted to carry on the use of a flat file rather than creating collections or adding a long list of applications to the Task Sequence, so I created (very quickly and messily) a script to import the file and build a list of applications to install. 

I add a variable near the start of my task sequence, after a Gather.ps1 step. (Currently using Gather.PS1 by Author: Johan Schrewelius, Onevinn AB),
Set Task Sequence Variable -> Variable: XXXCollectionName1, Value: BASE


A SCCM Script to load applications from a file called CustomSettings.ini and load them into the SCCM environment as variables


[BASE]
XXX00109:OSD_PAckageInstaller
packages001=XXX
packages002=

This will add multiple variables and increment the Packages###



Need to 
