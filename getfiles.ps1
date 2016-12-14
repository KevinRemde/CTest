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
        
            [Parameter(Mandatory)]
            [String]$FileURI
        ) 
    Node $MachineName
    {
        Script ConfigureVM 
        { 
	  	    SetScript = 
            { 
	            $FileURI = "https://cgiresources.blob.core.windows.net/files/files.zip"
                $dir = "c:\Files"
                New-Item $dir -ItemType directory
                $output = "$dir\Files.zip"
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
