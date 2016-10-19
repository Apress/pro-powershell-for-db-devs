function Out-UdfHTML ([string] $p_headingbackcolor, [switch] $AlternateRows)
{
  if ($AlternateRows) {$tr_alt = "TR:Nth-Child(Even) {Background-Color: #dddddd;}"}

  $format = @"
  <style>
  TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
  TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:   
  $p_headingbackcolor;}
  $tr_alt
  TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
  </style>
"@

  RETURN $format
}

# Code to call the function…
$datapath = $env:HOMEDRIVE + $env:HOMEPATH + "\Documents\"

$instates = Import-CSV ($datapath + “state_table.csv")

$instates | Select-Object -Property name, abbreviation, country, census_region_name | 
where-object -Property census_region_name -eq "Northeast" |
ConvertTo-HTML -Head (Out-UdfHTML "lightblue" -AlternateRows) -Pre "<h1>State List</h1>" -Post ("<h1>As of " + (Get-Date) + "</h1>") |
Out-File MyReport.HTML

Invoke-Item  MyReport.HTML  
