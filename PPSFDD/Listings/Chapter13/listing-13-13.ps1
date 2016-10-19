$filepath = $env:HOMEDRIVE + $env:HOMEPATH + "\Documents\"

function New-UdfFile ([string]$fullfilepath)
{
  for ($i=1; $i -le 30; $i++)
  {
    Get-ChildItem | Out-File ($fullfilepath) -Append
  } 
}

New-UdfFile ($filepath + "logfile1.txt")
New-UdfFile ($filepath + "logfile2.txt")
