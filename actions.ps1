# This file is the primary script that will perform API function calls to the Modules\API.ps1 file, and then action those API calls to the FMG.

# This first section imports the functions from the API.ps1 file.
$importAPI = @(Get-ChildItem -Path $PSScriptRoot\Modules\*.ps1 -ErrorAction SilentlyContinue)
Foreach ($import in @($importAPI)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Login to the FortiManager
$fmgIP = '<IPAddress>'
$fmg = FMG-Login($fmgIP)

# Use this space between Login and Logout to perform your desired actions. 
# When making calls to other API functions, send in $fmg.session as seen below in the logout function. This is the session key.
# Look inside Modules\API.ps1 for a better understanding of what actions you can perform presently with this API wrapper.

FMG-Logout($fmg.session)