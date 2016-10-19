function Invoke-UdfPipeProcess ( [Parameter(ValueFromPipeline=$True)]$mypipe = "default")

{

    begin { 
            Write-Host "Getting ready to process the pipe. `r`n"
          }

    process {  Write-Host "Processing : $mypipe"
            }         

    end {Write-Host "`r`nWhew!  That was a lot of work." }

}

# Code to call the function…
Set-Location  c:\
Get-ChildItem | Invoke-UdfPipeProcess  
