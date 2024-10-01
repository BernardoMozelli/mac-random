$WiFi = Get-NetAdapter -Name "Wi-Fi"

$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}"

($Key = Get-ItemProperty -Path "$RegPath\*" -Name "AdapterModel") 2> $Null

If ($Key.AdapterModel -eq $WiFi.InterfaceDescription){

New-ItemProperty -Path "$RegPath\$($Key.PSChildName)" -Name "NetworkAddress" -Value $($WiFi.MacAddress) -PropertyType String -Force}
