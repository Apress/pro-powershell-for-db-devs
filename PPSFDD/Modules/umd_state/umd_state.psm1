<#  Module Name:  umd_state.psm1

    Author:       Bryan Cafferky

    Purpose:      A module demostration.

#>
<# 
    .SYNOPSIS  
      Demonstrate the creation and use of a custom module written in PowerShell. 
       
    .Description 
          This module was created to demonstrate the use of custom PowerShell modules. 
     
     .Notes
          Author:  Bryan Cafferky for Pro PowerShell Development.
          Version: 1.0
         
#>

[string]$script:salestaxfilepath = ($env:HomeDrive + $env:HOMEPATH + "\Documents\StateSalesTaxRates.csv”)

$inexchangerate = Import-CSV ($env:HomeDrive + $env:HOMEPATH + "\Documents\currencyexchangerate.csv")

[hashtable]$script:salestax = @{}

function Set-UdfSalesTaxFilepath {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory = $true)]
            [ValidateScript({ Test-Path $_ })]
            [string]$p_taxfilepath
            )
            }
{
     $script:salestaxfilepath = $p_taxfilepath
} 

function Get-UdfSalesTaxFilepath
{
     Write-Host $script:salestaxfilepath
}


function Invoke-UdfStateRateLoad 
{

    $insalestax = Import-CSV $salestaxfilepath

    foreach ($item in $insalestax) {$script:salestax[$item.StateCode] = $item.SalesTaxRate} 

}

function Get-UdfStateTaxRate
{ 
 [CmdletBinding()]
        param (
          [string]    $p_statecode
          )

   if ($script:salestax.Count -eq 0)
   {
      "Here"
      Invoke-UdfStateRateLoad
   }

   $script:salestax["$p_statecode"]
   
}

#  Note:  Site: http://www.xe.com/currency/usd-us-dollar?r=  provided Currency Conversion values.

$exchangerate = Import-CSV ($env:HomeDrive + $env:HOMEPATH + "\Documents\currencyexchangerate.csv")

function Get-UdfExchangeRate
{ 
 [CmdletBinding()]
        param (
          [Parameter(Mandatory = $true, Position = 0)]
          [string]    $p_currencycd,
          [Parameter(Mandatory = $true, Position = 1)]
          [string]    $p_asofdate,
          [Parameter(Mandatory = $true, Position = 2, ParameterSetName = "unitsperusd")]
          [switch]    $UnitsPerUSD,
          [Parameter(Mandatory = $true, Position = 2, ParameterSetName = "usdperunits")]
          [switch]    $USDPerUnits,
          [Parameter(Mandatory = $true, Position = 2, ParameterSetName = "currencyname")]
          [switch]    $CurrencyName
          )

   foreach ($item in $exchangerate)  
   {
      if ($item.CurrencyCD -eq $p_currencycd -and $item.AsOfDate -eq $p_asofdate)
      {
          if ($CurrencyName) { Return $item.CurrencyName  }
          if ($UnitsPerUSD)  { Return $item.UnitsPerUSD   }
          if ($USDPerUnits)  { Return $item.USDPerUnit    }
      }

   }
 }
