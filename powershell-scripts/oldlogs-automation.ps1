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

# Mention logs path

$path = "C:\ProgramData\DotNetAgent\AgentLogs"

$limit = (Get-Date).AddDays(-30)

# Delete files older than the $limit.

Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item

# Delete any empty directories left behind after deleting the old files.

Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item  -Recurse
