#Select the folders from were you wan to remove the files
$tempfolders = @(“C:\Windows\Temp\*”, “C:\Windows\Prefetch\*”, “C:\Documents and Settings\*\Local Settings\temp\*”, “C:\Users\*\Appdata\Local\Temp\*”)

#Remove the files
Remove-Item $tempfolders -force -recurse
