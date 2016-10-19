Import-Module umd_northwind_etl -Force

Clear-Host

workflow Invoke-UdwNorthwindETL 
{

 parallel 

 {

    Invoke-UdfStateSalesTaxLoad

    Invoke-UdfOrderLoad

    Invoke-udfCustomerLoad

  }

}

Invoke-UdwNorthwindETL
