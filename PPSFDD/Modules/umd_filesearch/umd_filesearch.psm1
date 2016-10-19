function ufn_search_file ([string]$searchstring,[string] $outfilepath)
{
  begin
  {
   "" > $outfilepath  # Clear out file contents
  }
  process 
  {
   if ($_ -like "*txt*")
   {
    $_ >> $outfilepath
   }
  }
}