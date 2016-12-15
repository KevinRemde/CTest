<# 
The Files.zip file downloaded is just as an example, using some old hands-on lab content.
Those contents aren't important for the solution.

Yet to fix:
Currently hte $FileURI variable scope doesn't mean anything to the SetScript section below, so I temporarily 
had to hard-code the variable.  
I'm missing some syntax detail that I didn't have time to figure out.
#>    
Configuration getfiles
{
   param 
        (
            [Parameter(Mandatory)]
            [String]$MachineName,
            
            [String]$FileURI = "https://raw.githubusercontent.com/KevinRemde/CTest/master/files.zip"
        ) 
    Node $MachineName
    {
        Script ConfigureVM 
        { 
	  	    SetScript = 
            { 
                $FileURI
                $dir = "c:\files"
                New-Item $dir -ItemType directory
                $output = "$dir\files.zip"
                (New-Object System.Net.WebClient).DownloadFile($FileURI,$output)
            } 
		    TestScript = 
            { 
			    Test-Path c:\Files
		    } 
		    GetScript = { <# This must return a hash table #> }          
	    }   
    }
}
