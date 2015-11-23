function Test-MsolUserAppliedSku
{
<#
.Synopsis
   Determines if a user has a given SKU in O365
.DESCRIPTION
   Based on the specified Sku, this script will test the given user
   and return if they have the given Sku applied to their licenses or not.
.EXAMPLE
   Test-MsolUserAppliedSku -UserPrincipalName Gene@PowerShellNow.com -sku 'powershelnow:ENTERPRISEPACK'

   This example will return true if the user has the SKU 'powershellnow:ENTERPRISEPACK' applied in 
   their licenses. (This test is case insensitive)
#>
    [CmdletBinding()]
    [OutputType([boolean])]
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
                   ParameterSetName="MsolUserObject",
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [Parameter(ParameterSetName="UserPrincipalName")]
        $SKU
    )

    if ($PSBoundParameters.ContainsKey("UserPrincipalName"))
    {

        foreach ($Upn in $UserPrincipalName)
        {
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
                $false
                Continue
            }

            if ($null -ne $MsolUser)
            {
                Write-verbose "Accessed user object is not null."
                foreach ($skuId in $MsolUser.Licenses.accountskuid)
                {
                    Write-Verbose "User has sku: $skuId"
                }

                Write-Verbose "Searching user's SKUs for '$sku'"
                if ($MsolUser.Licenses.accountskuid -contains $SKU)
                {
                    $True
                }
                Else
                {
                    $False
                }
            }
            else
            {
                $False
            }
        }
    }

    if ($PSBoundParameters.ContainsKey("MsolUser"))
    {
        foreach ($User in $MsolUser)
        {
            foreach ($skuId in $User.Licenses.accountskuid)
            {
                Write-Verbose "User has sku: $skuId"
            }

            Write-Verbose "Searching user's SKUs for '$sku'"
            if ($User.Licenses.accountskuid -contains $SKU)
            {
                $True
            }
            Else
            {
                $False
            }
        }
    }
}
