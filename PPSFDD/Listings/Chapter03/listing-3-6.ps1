function New-UdfZipCodeObject {

 [CmdletBinding()]
        param (
              [ref]$zipobject
          )
          
    #  Load Zip Codes

    $zipcodes = Import-CSV ($env:HOMEDRIVE + $env:HOMEPATH + "\Documents\" + "free-zipcode-database.csv")

    $zipobject.value | Add-Member -MemberType noteproperty `
                            -Name ZipCodeData `
                            -Value $zipcodes

  #  Find Zip Codes...
  
    $bgetdataforzip = @'
     param([string] $zip)
   
     RETURN $this.ZipCodeData | where-object {$_.Zipcode -eq "$zip" }
'@

    $sgetdataforzip = [scriptblock]::create($bgetdataforzip)

    $zipobject.value | Add-Member -MemberType scriptmethod `
                            -Name GetZipDetails `
                            -Value $sgetdataforzip `
                            -Passthru
}

#  Code to use the function...

New-UdfZipCodeObject([ref]$mygeo)

# Note that we do not declare the $mygeo object variable as it already exists. 
# We pass it into the function to add zip code functionality, using the REF type again so the function can add to the object. 
# Let’s test the features added using the following code:
Write-Host "`r`nVerify a Zip Code is valid..."
$mygeo.ZipCodeData.Zipcode.Contains("02886")

Write-Host "`r`nGet the details for a zip code..."
$mygeo.GetZipDetails("02886")

Write-Host "`r`nGet the city or cities for a zip..."
$mygeo.GetZipDetails("02886").City 
