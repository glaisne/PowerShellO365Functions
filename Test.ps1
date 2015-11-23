#Get-Variable |Ft * -force -auto

$PSCommandPath
#$PSCommandPath |gm * |ft * -force -AutoSize
#Split-Path $PSCommandPath -Leaf

Get-ChildItem -path $PSScriptRoot -filter "*.ps1" |Where-Object { $_.fullname -ne $PSCommandPath} | foreach {
    gc $_ | out-file ""
}