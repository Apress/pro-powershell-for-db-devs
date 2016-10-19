function Set-UdfConfiguration { 
 [CmdletBinding()]
        param (
                [string]      $configpath   
              )
    [psobject] $config = New-Object psobject

    $projects   = Import-CSV -Path $configpath | Select-Object -Property Project -Unique 
    $configvals = Import-CSV -Path $configpath 

    foreach ($project in $projects) 
    {
        $configlist = @{}

        foreach ($item in $configvals) 
        {
            if ($item.project -eq $project.project )  { $configlist.Add($item.name, $item.value)  }
        }

        #  Add the noteproperty with the configuration hashtable as the value.
        $config | Add-Member -MemberType NoteProperty -Name $project.project -Value $configlist 
    }

    Return $config
    
}

$global:psappconfig = Set-UdfConfiguration ($env:psappconfigpath) 