    $localPath = "D:\ftp-test\"
    $remotePath = "/"
try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "D:\WinSCP-5.19.6-Automation\WinSCPnet.dll"  ## https://winscp.net/download/WinSCP-5.19.6-Automation.zip
 
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp # Port 22 Sftp | FTP Port: 21
        HostName = "hostnameftp.blob.core.windows.net" #IP TO FTP/SFTP
        UserName = "usernameftp.usernameftp" #USERNAME
        Password = "IQXWy65F9rzW/OvyhkEz125ssaff1d2f12dsds"  #PASSWORD LEAVE EMPTY IF YOU USE PRIVATE KEY LIKE THIS( Password = "" )
        SshHostKeyFingerprint = "ecdsa-sha2-nistp256 256 zBKGtf770MPVvxgqLl/4pJinGPJDlvh/mM963AwH6rs"
        #SshPrivateKeyPath= "C:\Users\Administrator\private.ppk" #If you youse password make "SshPrivateKeyPath" to a comment or delete the line!
    }
 
    $session = New-Object WinSCP.Session
 
    try
    {
        # Connect
        $session.Open($sessionOptions)
        $transferOptions = New-Object WinSCP.TransferOptions
        $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
        $transferResult =
            $session.GetFiles("/", "D:\wakeonlan", $False, $transferOptions) #Get files from /root/SFTP/ to D:\ftp-test\
            # Use $session.PutFiles(LocalPath, RemotePath) instead If you are wanting to send files to the SFTP/FTP Server.

        # Throw on any error
        $transferResult.Check()
 
        # Print results
        foreach ($transfer in $transferResult)
        {
           Write-Host "Download of $($transfer.FileName) to $localPath succeeded"
           $transferResult 
        }
    }
    finally
    {
        # Disconnect, clean up (Session.Close to exit the session!)
        $session.Close()        
    }
 
    exit 0
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
    
}
