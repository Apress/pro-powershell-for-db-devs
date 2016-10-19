function New-UdfStateObject   
{
 [CmdletBinding()]
        param (
              [ref]$stateobject
          )
  
    $instates = Import-CSV -PATH `
                (($env:HOMEDRIVE + $env:HOMEPATH + "\Documents\") + "state_table.csv")
   
   # Properties...
  
    $stateobject.value  | Add-Member -MemberType noteproperty `
                                     -Name statedata `
                                     -Value $instates `
                                     -Passthru

   [hashtable] $stateht = @{}
   foreach ($item in $instates) {$stateht[$item.abbreviation] = $item.name} 

   $stateobject.value  | Add-Member -MemberType noteproperty `
                                    -Name Code `
                                    -Value $stateht  `
                                    -Passthru

   [hashtable] $statenameht = @{}
   foreach ($item in $instates) {$statenameht[$item.name] = $item.abbreviation} 

   $stateobject.value  | Add-Member -MemberType noteproperty `
                                    -Name Name `
                                    -Value $statenameht `
                                    -Passthru

  #  Methods...
  
    $bshowdata = @'
       
     $this.statedata | Out-GridView 

'@

    $sshowdata = [scriptblock]::create($bshowdata)

    $stateobject.value | Add-Member -MemberType scriptmethod `
                                    -Name Show `
                                    -Value $sshowdata `
                                    -Passthru
} 

[psobject] $states1 = New-Object psobject
New-UdfStateObject ([ref]$states1) 

$states1.Code["RI"] 

$states1.Name["Vermont"]

#  Line below will displays states in a grid.
#  $states1.Show()
