function New-UdfGeoObject  () 
{
 [CmdletBinding()]
        param (
              [ref]$geoobject
          )
  
 #  Check if the SQL module is loaded and if not, load it.
     if(-not(Get-Module -name "sqlps")) 
        {
              Import-Module "sqlps" 
        }

   set-location SQLSERVER:\SQL\BryanCafferkyPC\DEFAULT\Databases\Adventureworks\Tables

   # Load Territory

   $territoryrs = Invoke-Sqlcmd -Query "SELECT distinct [Name],[CountryRegionCode] FROM   [AdventureWorks].[Sales].[SalesTerritory];" -QueryTimeout 3 

   $territoryhash = @{}
   foreach ($item in $territoryrs) {$territoryhash[$item.Name] = $item.CountryRegionCode} 

   $geoobject.value | Add-Member -MemberType noteproperty `
                           -Name Territory `
                           -Value $territoryhash

   #  Load Currency 

   $currencyrs = Invoke-Sqlcmd -Query "SELECT [CurrencyCode], [Name] FROM [AdventureWorks].[Sales].[Currency];" -QueryTimeout 3 

   $currencyhash = @{}
   foreach ($item in $currencyrs) {$currencyhash[$item.CurrencyCode] = $item.Name} 


   $geoobject.value | Add-Member -MemberType noteproperty `
                           -Name Currency `
                           -Value $currencyhash

    # Load CurrencyConversion

    $sql = "SELECT [FromCurrencyCode], [ToCurrencyCode],[AverageRate], [EndOfDayRate],cast([CurrencyRateDate] as date) as CurrencyRateDate  
            FROM [AdventureWorks].[Sales].[CurrencyRate]
            where [CurrencyRateDate] = (select max([CurrencyRateDate]) from [AdventureWorks].[Sales].[CurrencyRate]);"
     
    $convrate = @{}

    $convrate = Invoke-Sqlcmd -Query $sql -QueryTimeout 3 

    $geoobject.value | Add-Member -MemberType noteproperty `
                            -Name CurrencyConversion `
                            -Value $convrate

    #  Define Methods...
    
    #  Territory - Look Up Country 

    $bterritorytocountry = @'
    param([string] $territory)
    
    RETURN $this.Territory["$territory"]
'@

    $sterritorytocountry = [scriptblock]::create($bterritorytocountry)

    $geoobject.value | Add-Member 	-MemberType scriptmethod `
                            		-Name GetCountryForTerritory `
                            		-Value $sterritorytocountry `
                           		-Passthru

    $convertcurrency = @'
    param([string] $targetcurrency,[decimal] $amount)

     $row = $this.CurrencyConversion | where-object {$_["ToCurrencyCode"] -eq "$targetcurrency" }
     $result = $row["AverageRate"] * $amount
     RETURN $result
'@

    $sconvertcurrency = [scriptblock]::create($convertcurrency)

    $geoobject.value | Add-Member -MemberType scriptmethod `
                            -Name ConvertCurrency `
                            -Value $sconvertcurrency `
                            -Passthru
}
