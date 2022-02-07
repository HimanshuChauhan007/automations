#To get Admin privilege 

Write-Host "Checking for elevation... "
$CurrentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
if (($CurrentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) -eq $false)
{
  $ArgumentList = "-noprofile -file `"{0}`" -Path `"$Path`" -MaxStage $MaxStage"
  If ($ValidateOnly) { $ArgumentList = $ArgumentList + " -ValidateOnly" }
  If ($SkipValidation) { $ArgumentList = $ArgumentList + " -SkipValidation $SkipValidation" }
  If ($Mode) { $ArgumentLst = $ArgumentList + " -Mode $Mode" }
  Write-Host "elevating"
  Start-Process powershell.exe -Verb RunAs -ArgumentList ($ArgumentList -f ($myinvocation.MyCommand.Definition)) -Wait
  Exit
}
 
# Load IIS module:
Import-Module WebAdministration
 
# SET AppPool Name
$AppPoolName = "api.fontexplorerx.com"
 
# Start App Pool if stopped else restart
#Get the runtime state of the DefaultAppPool and checking the status
if ((Get-WebAppPoolState($AppPoolName)).Value -eq "Stopped")
  {
      Write-Output "Starting IIS app pool"
        #starting the App Pool
          Start-WebAppPool $AppPoolName
        }
else {
C:\Windows\System32\inetsrv\appcmd.exe stop appPool "$AppPoolName"
 
Start-Sleep -s 30
 
C:\Windows\System32\inetsrv\appcmd.exe start appPool "$AppPoolName"
 
Write-Output "Application pool is Running successfully"
}
