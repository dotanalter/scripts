$computers = Get-OnlineComputers -AllProperties | select -ExpandProperty name
$res = Invoke-Command -ComputerName $computers -ScriptBlock{
$BootTime = gwmi -Class win32_OperatingSystem
$localtime = $BootTime.ConvertToDateTime($BootTime.LocalDateTime)
$lastboot =  $BootTime.ConvertToDateTime($BootTime.LastBootUpTime)
$BootTime = $localtime - $lastboot

$hash = @{
    Days = $BootTime.Days
    Hours = $BootTime.Hours
}

$obj = New-Object psobject -Property $hash
Write-Output $obj
} 

$res | select PSComputerName , Days , Hours | sort Days , Hours -Descending| Format-Table -AutoSize 