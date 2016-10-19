Import-Module umd_database

function Set-UdfConfigurationFromDatabase 
{ 
 [CmdletBinding()]
        param (
                [string] $sqlserver,
                [string] $sqldb,
                [string] $sqltable   
              )

    [psobject] $config = New-Object psobject

    $projects = Invoke-UdfSQLQuery -sqlserver $sqlserver `
                                  -sqldatabase $sqldb   `
                                  -sqlquery "select distinct project from $sqltable;"

    $configrows = Invoke-UdfSQLQuery -sqlserver $sqlserver -sqldatabase $sqldb `
                                    -sqlquery "select * from $sqltable order by project, name;"
    
    foreach ($project in $projects) 
    {
        $configlist = @{}

        foreach ($configrow in $configrows) 
        {
            if ($configrow.project -eq $project.project )  
                  { $configlist.Add($configrow.name, $configrow.value)  }
        }

        #  Add the noteproperty with the configuration hashtable as the value.
        $config | Add-Member -MemberType NoteProperty -Name $project.project -Value $configlist 
    }
    
     Return $config
}

Set-UdfConfigurationFromDatabase '(local)' 'Development' 'dbo.PSAppConfig'
