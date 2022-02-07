$version = 1  

$displayname = "Connection Monitor"  

$heartbeat = "true"

$Connection = test-netconnection -ComputerName "IP or DNS" -Port 6379 -WarningAction SilentlyContinue

If($Connection.TcpTestSucceeded -ne $true){

   Write-Output "0" | Out-File "D:\Redis_TCE_Connection\imp_tce_redis_master_file.txt" 

}else { 

     Write-Output "1" | Out-File "D:\Redis_TCE_Connection\imp_tce_redis_master_file.txt"

}

$au = Get-Content -Path D:\Redis_TCE_Connection\imp_tce_redis_master_file.txt

#Display output on Site24*7 

$mainJson = @{}

$mainJson.Add("plugin_version", $version)

$mainJson.Add("heartbeat_required", $heartbeat)

$mainJson.Add("displayname", $displayname)

$mainJson.Add("Status", $au)

$mainJson | ConvertTo-Json
