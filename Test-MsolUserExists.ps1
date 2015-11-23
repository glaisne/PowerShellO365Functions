function Test-MsolUserExists
{
<#
.Synopsis
   Determines if a user exists in O365
.DESCRIPTION
   This function will return a simple $True or $False depending on the user's existence
   in Office365.
.EXAMPLE
   Test-MsolUser -UserPrincipalName Gene@PowerShellNow.com

   This example will return $true if Gene has a user in the cloud.
   It will return false if he does not.
#>
    [CmdletBinding()]
    [OutputType([boolean])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string[]]$UserPrincipalName
    )

    foreach ($upn in $UserPrincipalName)
    {
        if (Get-MsolUser -UserPrincipalName $upn -ErrorAction SilentlyContinue)
        {
            $True
        }
        Else
        {
            $False
        }
    }
}