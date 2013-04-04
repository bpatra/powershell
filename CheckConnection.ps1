$processName = "myprocesstokill"
$timeOut = [timespan]'0:0:15'

Function GetMyIPSync
{
    $wc1=New-Object net.webclient
    $wc1.downloadstring("http://checkip.dyndns.com") -replace "[^\d\.]"
}

$initialIp = GetMyIPSync

Write-Host "The ip that we will monitor is" $initialIp
Write-Host "...press q to Quit or any key to Continue."
$key = Read-Host
if($key -eq 'q'){ Exit }

$currentIp = $initialIp
$watch = [System.Diagnostics.Stopwatch]::StartNew()
$isSecondChance = $FALSE
while($currentIp -eq $initialIp){
    Write-Host "everything's fine connected with ip" $currentIp

    $wc=New-Object net.webclient
    $result = $wc.downloadstringtaskasync("http://checkip.dyndns.com")
    if ($result.AsyncWaitHandle.WaitOne($timeOut) -eq $false) 
    { 
        Write-Host "no connection within" $timeOut.TotalSeconds "seconds... second chance..."
        if($isSecondChance){
			break
		}
		[System.Threading.Thread]::Sleep([timespan]'0:0:35')
        $isSecondChance = $TRUE
		continue
    }
    else
    { 
        Write-Host "connection within" $timeOut.TotalSeconds "seconds"
        $currentIp = $result.Result -replace "[^\d\.]"
    }
    $wc.Dispose()
}

Write-Error "something's got wrong with ip... killing process..."
Get-Process | Where-Object{$_.ProcessName -match $processName} | ForEach-Object{ kill $_.Id}
Write-Host $processName "killed after" $watch.Elapsed.TotalMinutes "minutes"
Write-Host "Press any key to quit..."
Read-Host