### Remotely queries process information from a list of machines and outputs it to CSV

# Feel free to uncomment lines with variables ending in "GP" if you prefer to use Get-Process instead of Get-WmiObject

# Enter the name of the process you would like to monitor
$ProcessName = "chrome.exe"
# $ProcessNameGP = "chrome"

# Enter optional threshold for process memory working set usage in Megabytes. Processes that do not meet this value will be ignored.
$processMemoryThreshold = 60

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
ForEach ($machine in $machines) {

    # debug
    # Write-Output $machine

    # First, check that the machine is pingable. Skip it if it is not.
    If (!(Test-Connection -ComputerName $machine -Count 2 -Quiet)) {
        Write-Output "$machine was not pingable, please check the status of this system.`n"
    }

    # Special case where Get-Process doesn't work well with localhost
    ElseIf ($machine = "localhost") {
        # Grab the local machine info
        $chromeInfo = Get-WmiObject -Class Win32_Process -ComputerName $machine | Where-Object {($_.Name -like $ProcessName) -and (($_.ws / 1mb) -gt $processMemoryThreshold)} | Select-Object PSComputerName, ProcessName, @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}}, ProcessId, CommandLine
        $allChromeInfo += $chromeInfo

        # $chromeInfoGP = Get-Process -Name $ProcessNameGP -IncludeUserName | Select UserName, Name, @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}}, Id
        # $allChromeInfoGP += $chromeInfoGP
    }
    
    # Grab the remote machine info if it successfully pings
    Else {
        $chromeInfo = Get-WmiObject -Class Win32_Process -ComputerName $machine | Where-Object {($_.Name -like $ProcessName) -and (($_.ws / 1mb) -gt $processMemoryThreshold)} | Select-Object PSComputerName, ProcessName, @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}}, ProcessId, CommandLine
        $allChromeInfo += $chromeInfo
        
        # $chromeInfoGP = Get-Process -Name $ProcessNameGP -ComputerName $machine -IncludeUserName | Select UserName, Name, @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}}, Id
        # $allChromeInfoGP += $chromeInfoGP
        
    }

}

# Format result as a table and output it
$allChromeInfo | Format-Table -AutoSize
# $allChromeInfoGP | Format-Table -AutoSize

# Export result into CSV format
$allChromeInfo  | Export-Csv -NoType $PSScriptRoot\ChromeProcessTable-$Date.csv -append
# $allChromeInfoGP  | Export-Csv -NoType $PSScriptRoot\ChromeProcessTableGP-$Date.csv -append

Write-Output "Process export complete, you can find it at $PSScriptRoot\ChromeProcessTable-$Date.csv"
