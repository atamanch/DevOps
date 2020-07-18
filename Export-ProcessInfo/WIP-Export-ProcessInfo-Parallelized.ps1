### Remotely queries process information from a list of machines and outputs it to CSV

# The parallelization feature of this script only works in PowerShell 7
$PowerShellVersion = $PSVersionTable.PSVersion.Major

if (!($PowerShellVersion -ge 7)){
    Write-Output "Sorry, this script requires PowerShell 7 to run. You are running PowerShell $PowerShellVersion. 
Please try the non-parallelized version.
Exiting..."
    Exit
}

# Feel free to uncomment lines with variables ending in "GP" if you prefer to use Get-Process instead of Get-WmiObject

### TODO: Get-CIMInstance (used below) does not seem to work with variables, need to do further research on why this is the case.
### For now, Process and Working Set Size parameters can be entered manually on lines 56 / 67.

# Enter the name of the process you would like to monitor
$ProcessName = "chrome.exe"
# $ProcessNameGP = "chrome"

# Enter optional threshold for process memory working set usage in Megabytes. Processes that do not meet this value will be ignored.
$ProcMemThreshold = 60
$ProcMemThresholdBytes = $ProcMemThreshold * 1mb

$CIMFilter = "SELECT * from Win32_Process WHERE name LIKE '$ProcessName' AND workingsetsize > $ProcMemThresholdBytes"

# Create timestamp variable
$Date = Get-Date -Format "MMddyyyy"

# List machines here
$machines = @(
    "localhost"
    "localhost"
    "fakehost"
)

$allChromeInfo = @()
# $allChromeInfoGP = @()

# Loop through list, get process info and write it out to CSV
$machines | ForEach-Object -ThrottleLimit 10 -Parallel {

    # debug
    Write-Output $_

    $allChromeInfo = @()

    # Enter the name of the process you would like to monitor
    $ProcessName = "chrome.exe"
    # $ProcessNameGP = "chrome"

    # Enter optional threshold for process memory working set usage in Megabytes. Processes that do not meet this value will be ignored.
    $ProcMemThreshold = 60
    $ProcMemThresholdBytes = $ProcMemThreshold * 1mb

    $CIMFilter = "SELECT * from Win32_Process WHERE name LIKE '$ProcessName' AND workingsetsize > $ProcMemThresholdBytes"

    # First, check that the machine is pingable. Skip it if it is not.
    If (!(Test-Connection -ComputerName $_ -Count 2 -Quiet)) {
        Write-Output "$_ was not pingable, please check the status of this system.`n"
    }

    # Special case where Get-Process doesn't work well with localhost
    ElseIf ($_ = "localhost") {
        # Grab the local machine info
        $chromeInfo = Get-CimInstance -Query "$CIMFilter" | Select-Object @{Name="Computer Name";Expression={$_.CSName}}, @{Name="Process";Expression={$_.ProcessName}} , @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}}, ProcessId, CommandLine
        $allChromeInfo += $chromeInfo

        # $chromeInfoGP = Get-Process -Name $ProcessNameGP -IncludeUserName | Select UserName, Name, @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}}, Id
        # $allChromeInfoGP += $chromeInfoGP
    }
    
    # Grab the remote machine info if it successfully pings
    Else {
        $chromeInfo = Get-CimInstance -ComputerName $_ -Query "$CIMFilter" | Select-Object @{Name="Computer Name";Expression={$_.CSName}}, @{Name="Process";Expression={$_.ProcessName}} , @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}}, ProcessId, CommandLine
        $allChromeInfo += $chromeInfo
        
        # $chromeInfoGP = Get-Process -Name $ProcessNameGP -ComputerName $machine -IncludeUserName | Select UserName, Name, @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}}, Id
        # $allChromeInfoGP += $chromeInfoGP
    }

    #$allChromeInfo | Sort-Object -Property "Mem Usage(MB)" -Descending 

}

### TODO: Output to table and file is not currently working, need to dig into this.
# Format result as a table and output it
$allChromeInfo | Sort-Object -Property "Mem Usage(MB)" -Descending | Format-Table -AutoSize
# $allChromeInfoGP | Format-Table -AutoSize

# Export result into CSV format
$allChromeInfo | Sort-Object -Property "Mem Usage(MB)" -Descending | Export-Csv -NoType $PSScriptRoot\ChromeProcessTable-$Date.csv -append
# $allChromeInfoGP | Export-Csv -NoType $PSScriptRoot\ChromeProcessTableGP-$Date.csv -append

Write-Output "Process export complete, you can find it at $PSScriptRoot\ChromeProcessTable-$Date.csv"
