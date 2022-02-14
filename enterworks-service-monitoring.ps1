$version = 1  

$displayname = "Connection Monitor"  

$heartbeat = "true"

$serv = Get-Service -Include Enable* , EPX* -Exclude enable-es-indexer-service

if ( $serv.status -eq "Stopped")

      {

       Write-Output "0" | Out-File "Directory path.txt"

       }

       elseif ( $serv.status -eq "Running")

      {

       Write-Output "1" | Out-File "Directory path.txt"

        }

        $au = Get-Content -Path Directory path.txt

        $mainJson = @{}

$mainJson.Add("plugin_version", $version)

$mainJson.Add("heartbeat_required", $heartbeat)

$mainJson.Add("displayname", $displayname)

$mainJson.Add("Status", $au)

$mainJson | ConvertTo-Json 
