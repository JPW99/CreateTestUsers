#Create groups for testing

$Logfile = "C:\Temp\New_User_LOGFILE_$(Get-Date -Format yyyy-MM-DD-HHmm).txt"

Start-Transcript -Path $Logfile -Force -Confirm:$false

#Make sure ad module is installed
if (Get-Module -ListAvailable -Name ActiveDirectory) {
    Write-Host "AD Module exists, continuing to run"
} 
else {
    Write-Host "AD Module does not exist, Please install Remote Server Administration Tools (RSAT) and Try again"
    Pause
    Exit 10
}

#Import CSV of group names

Import-Csv -Path "D:\GROUPS.csv" | foreach {

    $groupName = $_.groupName.trim()
    $accName = $_.accName.trim()
    $groupCat = $_.groupCat.trim()
    $groupSco = $_.groupSco.trim()
    $display = $_.display.trim()
    $des = $_.des.trim()
    $Path = "OU=Groups,DC=TestingLab,DC=LOCAL"

      New-ADGroup -Name "$groupName" -SamAccountName $accName -GroupCategory $groupCat -GroupScope $groupSco -DisplayName "$display" -Path $Path -Description "$des"

        Write-Host "Group $groupName has been created."

}