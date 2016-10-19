function Show-UdfJobConsole
{
 [CmdletBinding()]
        param (
              [string]$jobnamefilter
          )

    function ufn_ShowMessageBox 
    { 
        [CmdletBinding()]
        param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)] 
        [string] $message,
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [string] $title,
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [ValidateRange(0,5)] 
        [int] $type 
        )
      
     RETURN [System.Windows.Forms.MessageBox]::Show($message , $title, $type)
    
    }
          
  $actions = "Show Output", "Stop", "Remove", "Resume", "Clear History"

  while ($true)
  {
  $joblist = Get-Job -Name $jobnamefilter | 
             Out-GridView -Title "PowerShell Job Console" -OutputMode Multiple 

  if ($joblist.count -gt 0) 
  { 
     $selection = $actions | Out-GridView -Title "Select Action" -OutputMode Single 
     foreach ($job in $joblist)
     {
        switch ($selection)  
        {
          "Show Output"
          { 
            $joboutput = Receive-Job -ID $job.ID -Keep -Verbose 4>&1 
            If ($joboutput -eq $null) 
            { 
               ufn_ShowMessageBox -message "No output to display" -title 'Error' -type 0
            }
            $joboutput | Out-GridView -Title 'Job Output - Close window to return to the job list' -Wait 
          } 
          "Cancel"
          { 
            $job | Stop-Job
          } 
          "Remove"
          { 
            $job | Remove-Job
          } 
          "Resume"
          { 
            $job | Resume-Job 
          } 
        }
     }
  } 
  else 
  { 
      Break;
  }
 }

} 

<# Example call... #>
  Show-UdfJobConsole '*'


