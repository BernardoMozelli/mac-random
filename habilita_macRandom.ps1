# Obtém o adaptador de rede Wi-Fi
$WiFi = Get-NetAdapter -Name "Wi-Fi"

# Caminho do registro para os adaptadores de rede
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}"

# Gera um endereço MAC aleatório
function Generate-RandomMacAddress {
    $mac = [byte[]](0..5 | ForEach-Object { Get-Random -Minimum 0 -Maximum 255 })
    $mac[0] = $mac[0] -bor 2 # Define o bit de local para que seja um endereço MAC local
    return ($mac | ForEach-Object { '{0:X2}' -f $_ }) -join ':'
}

$RandomMac = Generate-RandomMacAddress

# Obtém as chaves do registro onde a propriedade AdapterModel está definida
$Keys = Get-ItemProperty -Path "$RegPath\*" -Name "AdapterModel" 2> $null

foreach ($Key in $Keys) {
    # Verifica se a descrição do adaptador corresponde à descrição da interface Wi-Fi
    if ($Key.AdapterModel -eq $WiFi.InterfaceDescription) {
        # Define a propriedade NetworkAddress com o novo endereço MAC aleatório
        Set-ItemProperty -Path "$RegPath\$($Key.PSChildName)" -Name "NetworkAddress" -Value $RandomMac -Type String
    }
}

# Reinicia o adaptador para aplicar as mudanças
Restart-NetAdapter -Name "Wi-Fi" -Confirm:$false
