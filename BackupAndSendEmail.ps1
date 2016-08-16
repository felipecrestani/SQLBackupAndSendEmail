<#Backup Database and Send Email#>
$date = (Get-Date).ToString("ddMMyyyy")
$fileName = "C:\temp\bkp" + $date + ".bak"

<#Backup Database #>
Backup-SqlDatabase -ServerInstance localhost\sqlexpress -Database BDNAME -BackupAction Database -BackupFile $fileName

<#Zip Backup File#>
[Reflection.Assembly]::LoadWithPartialName( "System.IO.Compression.FileSystem" )
$src_folder = "C:\temp"
$destfile = "C:\BD\bkp" + $date + ".zip"
$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
$includebasedir = $false
[System.IO.Compression.ZipFile]::CreateFromDirectory($src_folder,$destfile,$compressionLevel, $includebasedir )
 
<#Send gmail - Check gmail config to allow send email#>
$User = "email@gmail.com"
$cred=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, ("GMAILPASSWORD" | ConvertTo-SecureString -asPlainText -Force)
$EmailTo = "email@gmail.com"
$EmailFrom = "email@gmail.com"
$Subject = "Backup BD Name" 
$Body = "Backup BD Name" 
$SMTPServer = "smtp.gmail.com" 
$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
$SMTPMessage.Attachments.Add($destfile)
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($cred.UserName, $cred.Password); 
$SMTPClient.Send($SMTPMessage)

<#Delete original backup file#>
Remove-Item $fileName

<#

Create Windows Schedule Task

powershell -File BackupAndSendEmail.ps1

:)

#>
