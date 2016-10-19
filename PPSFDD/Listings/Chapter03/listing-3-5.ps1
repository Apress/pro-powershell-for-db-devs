# Create the geo object...
[psobject]$mygeo = New-Object PSObject

New-UdfGeoObject ([ref]$mygeo)

#  Since this is a hash table, let's look up a territory by country...
Write-Host "`r`nTranslate Territory directly from Global Object not fully Qualified..."
$mygeo.Territory["Southeast"]

Write-Host "`r`nTranslate Territory using a custom method..."
$mygeo.GetCountryForTerritory("Southeast")

write-host "`r`nCurrency Keys..."
write-host $mygeo.currency.Keys

Write-Host "`r`nCurrency Values..."
write-host $mygeo.currency.Values

Write-Host "`r`nTranslate currency code to currency name..."
$mygeo.currency["FRF"]

Write-Host "`r`nLook up currency conversion row for USD to Japanese Yen..."
$mygeo.CurrencyConversion  | where-object {$_["ToCurrencyCode"] -eq "JPY" }

Write-Host "`r`nConvert currency from USD to Japanese Yen..."
$mygeo.ConvertCurrency("JPY", 150.00)  
