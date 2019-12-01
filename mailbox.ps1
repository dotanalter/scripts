$cred = Get-Credential
$session = New-PSSession -ConfigurationName microsoft.exchange -ConnectionUri http://ExchangeName/powershell -Credential $cred -Authentication Kerberos
Import-PSSession -Session $session
Enable-Mailbox xxx
Remove-PSSession -Session $session