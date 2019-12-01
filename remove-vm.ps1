$name = get-vm | Out-GridView -OutputMode Single -OutVariable vm | select -ExpandProperty Name
$ip = Test-Connection -ComputerName $name -Count 1 -ErrorAction SilentlyContinue | select -ExpandProperty IPV4Address | select -ExpandProperty IPAddressToString
if($ip -eq $null){$ip = (nslookup $name)[-2].split(" ")[-1]}
Invoke-Command -ComputerName "rptdhcp" -ScriptBlock {param($ip) Remove-DhcpServerv4ExclusionRange -ScopeId IP -StartRange $ip -EndRange $ip} -ArgumentList $ip
Stop-VM $name -Kill -Confirm
Remove-VM $name -DeletePermanently 
Remove-ADComputer $name -Confirm 
