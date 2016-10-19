Import-Module umd_database

$parmset = @()   # Create a collection object.

# Add the parameters we need to use...
$parmset += (Add-UdfParameter "@BusinessEntityID" "Input" "1" "int32" 0)
$parmset += (Add-UdfParameter "@NationalIDNumber" "Input" "295847284" "string" 15)
$parmset += (Add-UdfParameter "@BirthDate" "Input" "1964-02-02" "date" 0)
$parmset += (Add-UdfParameter "@MaritalStatus" "Input" "S" "string" 1)
$parmset += (Add-UdfParameter "@Gender" "Input" "M" "string" 1)
$parmset += (Add-UdfParameter "@JobTitle" "Output" "" "string" 50)
$parmset += (Add-UdfParameter "@HireDate" "Output" "" "date" 0)
$parmset += (Add-UdfParameter "@VacationHours" "Output" "" "int16" 0)

$parmset | Out-GridView  # Verify the parameters are correctly defined.
