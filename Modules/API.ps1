<#
This is an API wrapper to be used with FortiManagers.
Author: Bradley Rose
Initial Creation Date: 2021-10-26
#>

class FortiManager
{
    <#
        .SYNOPSIS
        Generates a FMG Object to be utilized throughout your actions.
        .DESCRIPTION
        This class generated a FortiManager object with properties:
        - $ipAddress: The IPv4 address of the target FortiManager
        - $session: The sessionID that is presented following a successful login.
        - $port: The port to be used for communication with the FMG. Defaults to 443
        - $urlBase: The base URL used for API communications. The specific URI changes within each function per the API call required.
    #>

    [IpAddress]$ipAddress
    [String]$session
    [Int]$port
    [String]$urlBase = "https://$fmgIP`:$port/"
}

function FMG-Login($fmgIP, $port=443)
{

    <#
        .SYNOPSIS
        Logs into a FortiManager device.
        .DESCRIPTION
        Logs into a FortiManager device with specified credentials. This API is NOT programmed to utilize API tokens. Things to note here:
        - The credentials specified **must** have API access within the FMG (System Settings > Administrators > [Username] > JSON API Access). 
        - The default port is 443. If this is different, you must specify your HTTPS access port in the function call. See below examples.
        - The returned object is the entire "FortiManager" object, and not just the session. In order to perform other functions with this logged in 
            session, you must provide the $returnedObject.session variable from your primary script file.
        .EXAMPLE
        FMG-Login('192.168.0.100')

        Logs into a FortiManager at 192.168.0.100.
        .EXAMPLE
        FMG-Login('192.168.0.100',8443)

        Logs into a FortiManager at 192.168.0.100:8443
    #>

    $fmg = [FortiManager]::new()
    $fmg.ipAddress = $fmgIP
    if ($port -ne 443)
    {
        $fmg.port = $port
    }
    $Credentials = Get-Credential -Message 'Please enter administrative credentials for your FortiManager'
    $uri = $fmg.urlBase + "jsonrpc"

    $JSON = @"
    {
        "id": 1,
        "method": "exec",
        "params": [
            {
                "data": {
                    "user": "$($Credentials.username)",
                    "passwd": "$($Credentials.GetNetworkCredential().password)"
                },
                "url": "/sys/login/user"
            }
        ]
    }
"@
    $session = Invoke-RestMethod -Uri $uri -Method POST -Body $JSON -ContentType "application/json"
    $fmg.session = $session.session

    return $fmg
}

function FMG-Logout($session)
{
    
    <#
        .SYNOPSIS
        Logs out of a FortiManager device.
        .DESCRIPTION
        Logs out of a FortiManager device with a specified session.
        .EXAMPLE
        FMG-Logout($fmg.session)

        Logs out of an existing FortiManager object stored at $fmg.
    #>

    $JSON = @"
    {
    "id": 1,
    "method": "exec",
    "params": [
        {
            "url": "/sys/logout"
        }
    ],
    "session": "$($session)"
}
"@
}

# This does nothing more than ignore self-signed certificate errors.
if (-not("dummy" -as [type])) {
    add-type -TypeDefinition @"
using System;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

public static class Dummy {
    public static bool ReturnTrue(object sender,
        X509Certificate certificate,
        X509Chain chain,
        SslPolicyErrors sslPolicyErrors) { return true; }

    public static RemoteCertificateValidationCallback GetDelegate() {
        return new RemoteCertificateValidationCallback(Dummy.ReturnTrue);
    }
}
"@
}

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = [dummy]::GetDelegate()
