set-location ($env:HOMEDRIVE + $env:HOMEPATH + "\Documents\") 

# Let's use Here strings to create our input files...

@"
Joe Jones|22 Main Street|Boston|MA|12345
Mary Smith|33 Mockingbird Lane|Providence|RI|02886
"@ > outfileex1.txt

@"
Tom Jones|11 Ellison Stree|Newton|MA|12345
Ellen Harris|12 Warick Aveneu|Warwick|RI|02885
"@ > outfileex2.txt

#  We could make these parameters but we'll just use variables so the code stands alone...
$sourcepath =  $env:HOMEDRIVE + $env:HOMEPATH + "\Documents"
$filter = "outfileex*.txt"

$filelist = Get-ChildItem -Path $sourcepath  -filter $filter

$targetpathfile =  $env:HOMEDRIVE + $env:HOMEPATH + "\Documents\outmergedex.txt"

try
{
 Remove-Item $targetpathfile -ErrorAction Stop
 }
catch
{
   "Error removing prior files."
    Write-Host $_.Exception.Message
}
finally
{
   Write-Host "Done removing file if it existed."
   "out files merged at " + (Get-Date) | out-file outmerge.log -append
}

foreach ($file in $filelist)
 {   
     "Merging file $file..."
     $fc = Get-Content $file
     foreach ($line in $fc)  {$line + "|" + $file.name >> $targetpathfile  } 
 }   

