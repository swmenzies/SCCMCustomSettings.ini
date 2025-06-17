# SCCM Dynamic Package Installation Script
# Reads local INI file and sets PACKAGES### variables based on set variables in the task sequence
# Sets PACKAGES### variables for "Install Software Packages according to Dynamic Variable List" step

# Initialise COM object for Task Sequence environment
try {
    $TSEnv = New-Object -ComObject Microsoft.SMS.TSEnvironment
    Write-Host "Task Sequence environment loaded successfully"
    # Get variables set in the TS. i.e Set Task Sequence Variable -> Variable: XXXCollectionName1, Value: BASE
    $CollectionName1 = $tsenv.Value("XXXCollectionName1")
    $CollectionName2 = $tsenv.Value("XXXCollectionName2")
    $CollectionName3 = $tsenv.Value("XXXCollectionName3")
    $CollectionName4 = $tsenv.Value("XXXCollectionName4")
    $CollectionName5 = $tsenv.Value("XXXCollectionName5")
    $Defaults = "Default"
} catch {
    Write-Error "Failed to load Task Sequence environment. This script must run in SCCM OSD context."
    exit 1
}

# Path to the CustomSettings.ini file (assumes it's in the same directory)
$iniPath = "CustomSettings.ini"

# Function to read and parse INI file with value-only support
function Read-IniFile {
    param ([string]$Path)
    
    $ini = @{}
    $section = ""
    foreach ($line in Get-Content $Path) {
        $line = $line.Trim()
        if ($line -match '^\s*\[([^\]]+)\]') {
            $section = $matches[1]
            $ini[$section] = @()
        } elseif (-not [string]::IsNullOrWhiteSpace($line) -and -not $line.StartsWith("#") -and $section) {
            $ini[$section] += $line
        }
    }
    return $ini
}

# Parse the INI file
$iniData = Read-IniFile -Path $iniPath

# Initialize counter and result list
$counter = 1
$appList = [System.Collections.Generic.List[string]]::new()

# Helper function to add apps from a section
function Add-AppsFromSection {
    param (
        [string]$SectionName
    )
    if ($iniData.ContainsKey($SectionName)) {
        foreach ($app in $iniData[$SectionName]) {
            $packageName = "Packages{0:D3}" -f $global:counter
            $entry = "$packageName=$app"
            $appList.Add($entry)
	        $TSEnv.Value("$PackageName") = $app
            write-host $packageName = $app
            $global:counter++
        }
    } else {
        Write-Host "Warning: Section [$SectionName] not found in the INI file." -ForegroundColor Yellow
    }
}

function Set-Defaults {
   param (
       [string]$SectionName
    )
    if ($iniData.ContainsKey("Default")) {
        Write-Host "inside first if."
        foreach ($TSSettings in $iniData["Default"]) {
            # If inside the [Default] section, parse key=value
            if ($TSSettings -match '^(.*?)=(.*)$') {
                $TSSetting = $matches[1].Trim()
                $TSValue = $matches[2].Trim()
            # Write Values into the SCCM TS
                $TSEnv.Value("$TSSetting") = $TSValue
                Write-Host $TSSetting = $TSValue
            }
        }
    }
}

# I need to add a loop for 1 to 5, and a default, for future development
if (-not [string]::IsNullOrWhiteSpace($CollectionName1)) {
    Add-AppsFromSection -SectionName $CollectionName1
}
if (-not [string]::IsNullOrWhiteSpace($CollectionName2)) {
    Add-AppsFromSection -SectionName $CollectionName2
}
if (-not [string]::IsNullOrWhiteSpace($CollectionName3)) {
    Add-AppsFromSection -SectionName $CollectionName3
}
if (-not [string]::IsNullOrWhiteSpace($CollectionName4)) {
    Add-AppsFromSection -SectionName $CollectionName4
}
if (-not [string]::IsNullOrWhiteSpace($CollectionName5)) {
    Add-AppsFromSection -SectionName $CollectionName5
}
if (-not [string]::IsNullOrWhiteSpace($Defaults)) {
    Write-Host "Loading defaults last"
    Set-Defaults
}

# Clean[?] exit from a powershell script 
exit 1
