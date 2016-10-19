$global:statelistglobal = Get-udfStatesFromDatabase # To load the global statelist uses Invoke-UdfValidateStateCode

$rootfolder = $env:HOMEDRIVE + $env:HOMEPATH + "\Documents\"

Invoke-UdfTestValidation $rootfolder 'MA'  # Passes - good path and state code

Invoke-UdfTestValidation $rootfolder 'XX'  # Fails - Invalid state code

Invoke-UdfTestValidation "c:\xyzdir" 'RI'  # Fails - Invalid path