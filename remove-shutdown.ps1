Write-Warning "did you remember to add the computer name to the common target in gpo?"
pause
$name = Read-Host -Prompt "enter computer name"
if((Test-Connection -ComputerName $name -Count 1 -ErrorAction Ignore) -ne $null)
{
    $s = New-PSSession -ComputerName $name -Verbose
    Invoke-Command -Session $s -ScriptBlock{
        $computerName = gwmi -Class win32_computersystem | select -ExpandProperty Name
        $ans = Read-Host -Prompt "$computerName is the correct computer? [y/n]"
        if($ans -eq "y" -or $ans -eq "Y")
        {
            if((schtasks /Query /TN ShutDown) -ne $null)
            {
                schtasks /Delete /TN ShutDown /F
                gpupdate /Force
                if((schtasks /Query /TN ShutDown) -eq $null)
                {
                    Write-Host "succeed" -ForegroundColor Green
                }
                else
                {
                    Write-Error "something wrong"
                }
            }
            else
            {
                Write-Error "there is no task"
            }
        }
        else
        {
            Write-Error "don't succeeded enter pssession"
        }
    }
}
else
{
    Write-Error "there is no connection to the computer"
}

Exit-PSSession -Verbose
pause
