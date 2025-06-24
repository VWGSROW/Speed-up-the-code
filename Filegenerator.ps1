Measure-Command{
$bigFileName = (Get-Location).Path +"\plc_log.txt"
$plcNames = @('PLC_A','PLC_B','PLC_C','PLC_D')
$errorTypes = @(
    'Sandextrator overload',
    'Conveyor misalignment',
    'Valve stuck',
    'Temperature warning'
)
$statusCodes = @('OK','WARN','ERR')
$list = [System.Collections.Generic.List[string]]::new(50000)
$randomObject = New-Object -TypeName System.Random
$date = Get-Date

for ($i=0; $i -lt 50000; $i++) {
    $timestamp = "{0:yyyy-MM-dd HH:mm:ss}" -f $date.AddSeconds(-$i)
    $plc = $plcNames[$randomObject.Next(0,3)]
    $operator = $randomObject.Next(101,121)
    $batch = $randomObject.Next(1000,1101)
    $status = $statusCodes[$randomObject.next(0,2)]  
    $machineTemp = [math]::Round(($randomObject.next(60,110)) + ($randomObject.next()),2) 
    $load = $randomObject.Next(0,101)

    if ($randomObject.next(1,8) -eq 4) {
        $errorType = $errorTypes[$randomObject.next(0,3)] 
        if ($errorType -eq 'Sandextrator overload') {
            $value = $randomObject.next(1,11)
            $msg = "ERROR; $timestamp; $plc; $errorType; $value; $status; $operator; $batch; $machineTemp; $load"
        } else {
            $msg = "ERROR; $timestamp; $plc; $errorType; ; $status; $operator; $batch; $machineTemp; $load"
        }
    } else {
        $msg = "INFO; $timestamp; $plc; System running normally; ; $status; $operator; $batch; $machineTemp; $load"
    }

    $list.Add($msg)
}

$stream = New-Object IO.StreamWriter $bigFileName, $true

foreach ($item in $list) {
    $stream.WriteLine($item)
}

$stream.Close()

Write-Output "PLC log file generated."
}
