Start-Transcript -Path C:\Scripts\DBserverDsc.Log
Write-Host "Provisioning $($env:COMPUTERNAME)"

configuration LocalIIS {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Node $ComputerName {

        WindowsFeature ADDSInstall
        { 
            Name = "AD-Domain-Services"
            Ensure = "Present" 
        } 
        
    }
}
$computername = 'localhost'

LocalIIS -OutputPath c:\DSC\Config

Start-DscConfiguration -Path C:\DSC\Config -ComputerName localhost

Write-Host "DSC Configuration Started."

Stop-Transcript
