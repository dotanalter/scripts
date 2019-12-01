Connect-VIServer -server IP
$name = "TestCLI"

New-ADComputer -Name $name -Path "xxx" -Enabled $true
Add-ADGroupMember "xxx" -Members "$name$"

$temp = Get-Template -Name "Windows Server 2016 Template"
$spec = Get-OSCustomizationSpec -Name "customVM"
$res = Get-Cluster -Name "Cluster"
Get-Datastore | sort -Descending FreeSpaceGB | Out-GridView -OutputMode Single -OutVariable datastore | Out-Null

Read-Host "if you want to extend disk C: enter a number(in GB)" -OutVariable extend  | Out-Null
if($extend -match '^\d+$' -and $extend -ge 0 -and $extend -le 500){$BoolExtend = $true}else{$BoolExtend = $false}

New-VM -Name $name -Template $temp -OSCustomizationSpec $spec -ResourcePool $res -Datastore $datastore.Name

if($BoolExtend){
Get-VM -Name $name |  Get-HardDisk | Set-HardDisk -CapacityGB $extend
}

Start-VM -VM $name | Out-Null
#wait until computer on
while(!(Test-Connection -ComputerName $name -count 1 -Quiet)){
sleep -Seconds 1
Write-Host "wait"
}

$ip = Test-Connection -ComputerName $name -Count 1 | select -ExpandProperty IPV4Address | select -ExpandProperty IPAddressToString
#create exclusion range in dhcp
Invoke-Command -ComputerName "rptdhcp" -ScriptBlock {param($ip) Add-DhcpServerv4ExclusionRange -ScopeId IP -StartRange $ip -EndRange $ip} -ArgumentList $ip

#chnge the ip from dynamic to static
Invoke-Command -ComputerName $name -ScriptBlock{
param($BoolExtend)
if($BoolExtend){
    $size = (Get-PartitionSupportedSize -DriveLetter C).SizeMax
    Resize-Partition -DriveLetter C -Size $size 
}
$currentIP = Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin dhcp
$currentGateway = (Get-NetIPConfiguration -InterfaceIndex $currentIP.InterfaceIndex).IPv4DefaultGateway.NextHop
Set-NetIPInterface -InterfaceIndex $currentIP.InterfaceIndex -Dhcp Disabled

New-NetIPAddress -IPAddress $currentIP.IPAddress -InterfaceAlias $currentIP.InterfaceAlias -Type $currentIP.Type -PrefixLength $currentIP.PrefixLength
New-NetRoute -InterfaceIndex $currentIP.InterfaceIndex -DestinationPrefix "0.0.0.0/0" -AddressFamily IPv4 -NextHop $currentGateway
Set-DnsClientServerAddress -InterfaceIndex $currentIP.InterfaceIndex -ServerAddresses ("IP","IP")
} -ArgumentList $BoolExtend