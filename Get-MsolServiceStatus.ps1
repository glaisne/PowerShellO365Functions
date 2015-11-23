function Get-MsolServiceStatus
{
<#
.Synopsis
   Get an Office365 user's Service Status
.DESCRIPTION
   This script will gather all the services in a given license for a specified user
   and return their individual statuses.
.EXAMPLE
   Test-MsolUserAppliedSku -UserPrincipalName Gene@PowerShellNow.com -sku 'powershelnow:ENTERPRISEPACK'
   
   This example gather all the serivices in a given license, specified by SKU, 
   and returns their status.
#>
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ParameterSetName="UserPrincipalName",
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]] $UserPrincipalName,

        [Parameter(Mandatory=$true,
                   ParameterSetName="MsolUserObject",
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [Microsoft.Online.Administration.User[]] $MsolUser,
        
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string]   $SKU
    )

    if ($PSBoundParameters.ContainsKey("UserPrincipalName"))
    {



        foreach ($upn in $UserPrincipalName)
        {
            $ServiceStatus
            $MsolUser = $null
            Write-Verbose "Attempting to access MS Online user $upn."
            try
            {
                $MsolUser = Get-MsolUser -UserPrincipalName $upn -ErrorAction Stop
               Write-Verbose "Successfully accessed MS Online user $upn."
            }
            catch
            {
                $err = $_
                Write-Error -Exception $err.Exception -Message "Unable to access MS Online account for $upn : $($err.message)" -TargetObject $upn
            }

            if ($null -ne $MsolUser)
            {
                Write-verbose "Accessed user object is not null."
                $FoundSku = $False
                foreach ($License in $MsolUser.Licenses)
                {
                    if ($License.AccountSkuId -eq $SKU)
                    {
                        Write-verbose "This user has the proper SKU applied."
                        $License.ServiceStatus
                        $FoundSku = $True
                        break
                    }
                }

            }
            else
            {
                $null
            }

            if (-not $FoundSku)
            {
                Write-verbose "The SKU was not found on this user."
                $null
            }
        }
    }

    if ($PSBoundParameters.ContainsKey("MsolUser"))
    {
        $FoundSku = $False
        foreach ($License in $MsolUser.Licenses)
        {
            if ($License.AccountSkuId -eq $SKU)
            {
                Write-verbose "This user has the proper SKU applied."
                $License.ServiceStatus
                $FoundSku = $True
                break
            }
        }
    }
}