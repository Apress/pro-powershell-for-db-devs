Import-Module umd_northwind_etl -Force

workflow Invoke-UdwNorthwindETL 
{

 parallel 

 {

   workflow Invoke-UdwStateSalesTaxLoad 
   {
    Invoke-UdfStateSalesTaxLoad 
   }
   Invoke-UdwStateSalesTaxLoad -PSComputerName remotepc1

   workflow Invoke-UfwOrderLoad  
   {
    Invoke-UdfOrderLoad 
   }
   Invoke-UfwOrderLoad  -PSComputerName remotepc2
  }

}

Invoke-UdwNorthwindETL 
