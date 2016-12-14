<#
The application of this DCS configuration adds the web server and 
MSMQ roles and features as required.
#>   
Configuration WebHost
{
    param
    (
        [Int]$RetryCount=20,
        [Int]$RetryIntervalSec=30,
        [String]$SystemTimeZone="Eastern Standard Time"
    )

    Import-DscResource -ModuleName xDisk, cDisk, PSDesiredStateConfiguration, xTimeZone 
    Node localhost 
    {
        LocalConfigurationManager
        {
            ConfigurationMode = 'ApplyOnly'
            RebootNodeIfNeeded = $true
        }
        
        # Set the TimeZone
        xTimeZone TimeZoneExample
        {
            TimeZone = $SystemTimeZone
            IsSingleInstance = "Yes"
        }

        # Install the IIS role 
        WindowsFeature IIS 
        { 
            Ensure          = "Present" 
            Name            = "Web-Server" 
        } 
        
        # Install the ASP .NET 4.5 role 
        WindowsFeature AspNet45 
        { 
            Ensure          = "Present" 
            Name            = "Web-Asp-Net45" 
        } 

        WindowsFeature WebStaticContent
        { 
            Ensure          = "Present" 
            Name            = "Web-Static-Content" 
        } 

        WindowsFeature WebStatCompression
        { 
            Ensure          = "Present" 
            Name            = "Web-Stat-Compression"
        } 

        WindowsFeature WebDynCompression
        { 
            Ensure          = "Present" 
            Name            = "Web-Dyn-Compression"
        } 

        WindowsFeature WebMgmtConsole
        { 
            Ensure          = "Present" 
            Name            = "Web-Mgmt-Console"
        }

        WindowsFeature FileServer 
	    {
            Ensure          = "Present"
            Name            = "FS-FileServer"
        }
        
	    WindowsFeature MessageQueueFeature
	    {
	        Ensure          = "Present"
	        Name            = "MSMQ"
	    }

	    WindowsFeature MessageQueueTriggers
	    {
	        Ensure          = "Present"
	        Name            = "MSMQ-Triggers"
	    }
        xWaitforDisk Disk2
        {
            DiskNumber = 2
            RetryIntervalSec =$RetryIntervalSec
            RetryCount = $RetryCount
        }

        cDiskNoRestart ADDataDisk
        {
            DiskNumber = 2
            DriveLetter = "F"
            DependsOn="[xWaitforDisk]Disk2"
        }
    }
}
