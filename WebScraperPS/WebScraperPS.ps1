# Web Scraping Script to detect changes in a web page
# A Future feature will be to email upon detection of a change

# Set some execution variables
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$StateFile = $ScriptDir+"\StateFile.txt"
$Date = Get-Date
$HashUpdateDate = "`nThe websites hash was last updated on " + $Date

# URL to website goes here, as well as the search pattern we want to filter on later
# You will want to tweak these depending on the structure of the site you want to monitor
$Website = "https://club.commonhealth.com.tw/channel/70"
$SearchPattern = "https://club.commonhealth.com.tw/article*"

# Get the HTTP response from the website
$Response = Invoke-WebRequest -URI $Website

# Filter the response down by strings that much the search pattern
$ResponseContent = $Response.Links | Select href | Select-String -Pattern $SearchPattern

# Compute the hash from the above filter response
$MD5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$UTF8 = New-Object -TypeName System.Text.UTF8Encoding
$Hash = [System.BitConverter]::ToString($MD5.ComputeHash($UTF8.GetBytes($ResponseContent)))

# Output the hash to output
Write-Verbose "`nSite links produce this hash: $Hash `n"

$CurrentStateFileOutput = $Hash + $HashUpdateDate

# Get previous statefile if it exists and variablize the content
if (test-path $StateFile){
    $OldStateFile = Get-Content $StateFile | Out-String
    $OldStateFileHash = ($OldStateFile.Split([Environment]::NewLine)[0])
    $OldStateFileDate = ($OldStateFile.Split([Environment]::NewLine)[1])


    # Check if old and new states match
    if ($Hash -ne $OldStateFileHash){

        Write-Output "The current website links do not match the site's previous crawls. `n" `
        "You may want to check this out. `n" `

        Compare-Object $Hash $OldStateFileHash

        "`nOverwriting current state to statefile $StateFile"



        $CurrentStateFileOutput | Out-File $StateFile -Encoding UTF8

        # TODO 
        # Create email and send it
    }

    else {

        Write-Output "No differences found in website," `
        "$OldStateFileDate"

    }
}
else{

    Write-Output "State file is missing, creating one now at $StateFile"
    $CurrentStateFileOutput | Out-File $StateFile

}