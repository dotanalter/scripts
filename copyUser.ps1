$tempUser = Get-ADUser xxx -Properties *
$DistinguishedName = $tempUser.DistinguishedName.Substring(($tempUser.DistinguishedName.IndexOf("OU=")))
# Get-ADUser -Filter * -SearchBase "$DistinguishedName" | select Name
$accountName = "teste"
$pass = ConvertTo-SecureString -String xxx -AsPlainText -Force
New-ADUser -Path "$DistinguishedName" -SamAccountName $accountName -Name "xxx" -GivenName "xxx" -Surname "xxx" -UserPrincipalName "$accountName@DomainName" -AccountPassword $pass -ChangePasswordAtLogon $true -Enabled $true 



$test = Get-ADUser teste -Properties *

foreach($g in $tempUser.MemberOf)
{
Add-ADGroupMember -Identity "$g" -Members $test
}

# ליצור תיקיית K ו Y ולתת הרשאות