Function Get-OnlineComputers() {

    param(
    [String] $Filter , 
    [switch] $AllProperties
        )
    
    $pingTest = $null

    if ($Filter){$Filter = "-and ($Filter)"}

    If($AllProperties){
        $computers =Invoke-Expression "Get-ADComputer -Filter {Enabled -eq `$true $Filter }  -Property *"
    }
    Else {
        $computers = Invoke-Expression "Get-ADComputer -Filter {Enabled -eq `$true $Filter }"
    }


    
    ForEach($computer in $computers) {

        $pingTest = Test-Connection -ComputerName $computer.Name -Count 1 -BufferSize 16 -AsJob
        $computer | Add-Member -NotePropertyName "PingJob" -NotePropertyValue $pingTest -Force
        $computer | Add-Member -NotePropertyName "PingReturn" -NotePropertyValue $null -Force

    }

    Get-Job -Command Test-Connection | Wait-Job | Out-Null

    ForEach($computer in $computers){

        If($computer.PingReturn -eq $null){

            $computer.PingReturn = Receive-Job $computer.PingJob

        }

    }

    Get-Job | Remove-Job -force
    $computers = $computers | Where-Object {$_.PingReturn.StatusCode -eq 0} | Select-Object -Property * -ExcludeProperty PingJob,PingReturn
    $computers
}