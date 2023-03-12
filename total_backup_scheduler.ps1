$EthernetName = "Ethernet 3"
$task0 = {Write-Output "Welcome iSolve"}
$job = {netsh interface set interface "$EthernetName" ENABLED}
$task2 = {Set-Disk -Number 1 -IsOffline $False}
$task3 = 
{
Write-Output "109-Backup Processing"
Write-Output ""
Write-Output "Please Don't close"
$date = Get-Date -Format "dd-mm-yyyy HH mm ss"
$folder = "C:\109_backup-2nd\$date"
New-Item -ItemType Directory -Path $folder
$source = "D:\Mohan_Develop_Data_27122022"
$destination = $folder
Get-ChildItem $source  -Filter *.RAR | ForEach-Object {
    Copy-Item $_.FullName -Destination $destination -Recurse}
}
$task4 = {Set-Disk -Number 1 -IsOffline $True}
$task5 = 
{
$adapter = Get-NetAdapter | Where-Object {$_.Name -eq "$EthernetName"}
$adapter | Disable-NetAdapter -Confirm:$false
}
#$tasks = [System.Collections.ArrayList]@($task1,$task2,$task3,$task4,$task5)
# Iterate through the tasks and execute each one
$tasks = @($task0,$job,$task2, $task3,$task4,$task5)
For ($i = 0; $i -le $tasks.length;$i++) {
   & $tasks[$i]}
