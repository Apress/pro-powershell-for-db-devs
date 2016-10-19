workflow simpleinline ([string] $myparm)
{
  inlinescript 
  { 
     Write-Verbose "Parameter is $Using:myparm"

     $object = New-Object PSObject 

     $object | Add-Member -MemberType NoteProperty -Name MyProperty -Value 'something'

     $object.MyProperty 
  }
}

simpleinline 'test' –Verbose
