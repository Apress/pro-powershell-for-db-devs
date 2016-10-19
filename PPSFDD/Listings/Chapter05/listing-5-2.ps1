function Invoke-UdfGetHelp   
{
[cmdletBinding(HelpURI="http://www.microsoft.com/en-us/default.aspx")]
        param (
            )

  Write-Host "Just to show the HelpURI attribute."
}

Get-Help -Online Invoke-UdfHelp     