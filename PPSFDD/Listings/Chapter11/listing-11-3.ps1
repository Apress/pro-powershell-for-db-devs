Import-Module umd_etl_functions

$salestax = Import-CSV ($env:HomeDrive + $env:HOMEPATH + "\Documents\StateSalesTaxRates.csv")
$salestax | Invoke-UdfStateTaxFileTransformation 
