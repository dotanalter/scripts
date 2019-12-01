$computers = Get-OnlineComputers | ?{$_.Name -notlike "*"} |select -ExpandProperty Name

#open excel report
$excel = New-Object -ComObject excel.application
$excel.Visible = $true
$file = $excel.Workbooks.Open("path.xlsx")
$name = "map"
$report = $file.Sheets.item($name)
$report.Select()
$countComputers = 2
$ErrorActionPreference = "SilentlyContinue"
$report.Range(("K2")).value2 = (Get-Date).ToString()

#delete old data
$range = $report.Range("A2","J300")
$range.clear()

foreach($computer in $computers)
{
    Write-Output "$computer"
    
        $report.Range(("B" + $countComputers)).value2 = "$computer"

        $model = (gwmi win32_computersystem -ComputerName $computer).Model
        $report.Range(("C" + $countComputers)).value2 = "$model"

        $serialComputer = (gwmi win32_bios -ComputerName $computer).SerialNumber
        $report.Range(("D" + $countComputers)).value2 = "$serialComputer"

        $monitors = gwmi WmiMonitorID  -Namespace root\wmi -ComputerName $computer
    
        if($monitors -ne $null)
        {
            $countMonitors = 0
            foreach($monitor in $monitors)
            {
                $serialMonitor = ($monitor.SerialNumberID -ne 0 | foreach{[char]$_}) -join ''
                $friendlyName = ($monitor.UserFriendlyName -ne 0 | foreach{[char]$_}) -join ''

                if($countMonitors -eq 0)
                {
                   $report.Range(("E" + $countComputers)).value2 = "$friendlyName"
                   $report.Range(("F" + $countComputers)).value2 = "$serialMonitor" 
                }
                else
                {
                   $report.Range(("G" + $countComputers)).value2 = "$friendlyName"
                   $report.Range(("H" + $countComputers)).value2 = "$serialMonitor"   
                }
                $countMonitors++
            }
        }
        $x = query USER /SERVER:$computer
        for($i = 1 ; $i -le ($x.Count - 1) ; $i++)
        {
            $username = $x[$i].Split(" ")[1]
            $name = (Get-ADUser $username).Name
            if($i -eq 1)
            {
                $report.Range(("A" + $countComputers)).value2 = "$name"
            }
            elseif($i -eq 2)
            {
                $report.Range(("I" + $countComputers)).value2 = "$name"
            }
            elseif($i -eq 3)
            {
                $report.Range(("J" + $countComputers)).value2 = "$name"
            }
        }
   
    $countComputers++
}
#close and save excel report 
$file.Save()
$file | % {$_.Close()}
$excel.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel)
