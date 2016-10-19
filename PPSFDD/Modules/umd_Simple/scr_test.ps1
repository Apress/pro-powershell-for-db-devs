Remove-Module umd_Simple
$test = New-object PSObject

$test = Import-Module umd_Simple -AsCustomObject

$test.myvar

$test.myvar = "Swell"

$newtest = New-object PSObject

$newtest = Import-Module umd_Simple -AsCustomObject


$newtest.myvar


