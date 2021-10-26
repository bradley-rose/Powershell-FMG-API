# FortiManager API with Powershell
This is an API wrapper built with Powershell to interact with a FortiManager device. This was purpose-built for environments without existing network automation tools such as Ansible, and/or access to programming languages such as Python. This can work on most locked-down enterprise systems, even for devices without local administrator or domain administrator account access, and even remote jump-servers through software-defined perimeters.

## Description
This script was built to be used on any Windows system that will interact with a FortiManager appliance for network automation. By calling your target script with `powershell.exe -ExecutionPolicy bypass`, you can still make full use of network automation as a low-privileged user. This circumvents not having access to any other programming environments on your machine. PowerShell comes installed by default on Windows, and there are ways to run scripts regardless of the restrictions set by Group Policies.

Say no more! Let's get started with network automation.

## Getting Started
### Dependencies
- This was tested on PowerShell 5.1, so I would suggest this as a minimum version.
- Windows 10 (probably works on 11, but has not been tested)
- This was also built for a FortiManager on v6.2, so if there are any variances to your FMG version, there may be issues depending on Fortinet's management of changes and version control. You may have to modify the API functions slightly to adapt it to your FMG version.
- Experience with class structures / PowerShell in general. It's mostly straightforward, but existing programming knowledge will help here.

### Usage Instructions
1. Clone this entire project, or just download it as a .zip and extract it on a machine which has access to the target FortiManager appliance via HTTPS. This can be a remote server.
2. Open the `actions.ps1` file, and insert your FMG IPv4 Address into the value for `$fmgIP` on line 11. 

```ps1
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
```

I have not, and am not planning on developing every action; just the ones that I will use at my organization. 
Please feel free to implement your own actions using the API documentation from the [Fortinet Developer Network](https://fndn.fortinet.net).

## Help
I am first and foremost a junior network administrator. My programming knowledge is extremely limited, and this may be visible in the programming standards here. If you would like to provide inputs, or simply just change the layouts here privately, please do! This is hopefully simple enough to be able to be able to copy/paste to a target machine and get started very simply. 

## Authors
- Myself, Bradley Rose
- [LinkedIn](https://linkedin.com/in/bradley-rose)
- Email: [contact@bradleyrose.co](mailto:contact@bradleyrose.co?subject=[GitHub]%20FortiManager%20API%20with%20PowerShell)

## Acknowledgements
The general structure of this API wrapper comes from @jsimpso with the [Python FortiGate API](https://github.com/PyFortiAPI/PyFortiAPI). I initially was testing API usage with Python, but ended up opting into PowerShell for ease of use on our enterprise systems. I've integrated the general class and API structure of this library to here.

