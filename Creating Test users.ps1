#Creating Test users
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

#importCSV containing users names, numbers and jobtitles

Import-Csv -Path "D:\Employees.csv" | foreach {

$firstName = $_.firstName.trim()
$lastName = $_.lastName.trim()
$Number = $_.employeeNumber.trim()
$jobTile = $_.jobTitle.trim()
$UserName = "$firstName.$lastName"
$DC = "OU=LabUsers,DC=TestingLab,DC=LOCAL"

#Set random password of 14 characters
[char[]]$chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*<>/?=+\-_'
$Password = ($chars | Get-Random -count 14) -join ""

#print users full name, number, job title, username and password
Write-Host "Users full name is $firstName $lastName. Their number is $Number with the job title of $jobTile and user name of $UserName. The users password will be $Password"


#Create user
New-ADUser `
    -Name "$firstName $lastName" `
    -GivenName "$firstName" `
    -Surname "$lastName" `
    -SamAccountName "$UserName" `
    -Title "$jobTile" `
    -department "Test" `
    -Company "Test" `
    -DisplayName "Test" `
    -office "Test" `
    -UserPrincipalName "$UserName" `
    -Enabled $true `
    -accountPassword $Password
}
Stop-Transcript

notepad.exe $Logfile
