#  Check if the SQL module is loaded and if not, load it.
if(-not(Get-Module -name "sqlps")) 
{
  Import-Module "sqlps" 
}

set-location SQLSERVER:\SQL\BryanCafferkyPC\DEFAULT\Databases\Adventureworks\Tables

$territoryrs = Invoke-Sqlcmd -Query "SELECT [StateProvinceID],[TaxType],[TaxRate],[Name] FROM [AdventureWorks].[Sales].[SalesTaxRate];" -QueryTimeout 3 

$excel = New-Object -ComObject Excel.Application

$excel.Visible = $true  # Show us what’s happening

$workbook = $excel.Workbooks.Add()  # Create a new worksheet

$sheet = $workbook.ActiveSheet # and make it the active worksheet.

$counter = 0

# Load the worksheet
foreach ($item in $territoryrs) {

    $counter++

    $sheet.cells.Item($counter,1) = $item.StateProvinceID
    $sheet.cells.Item($counter,2) = $item.TaxType
    $sheet.cells.Item($counter,3) = $item.TaxRate
    $sheet.cells.Item($counter,4) = $item.Name
}

#  Exporting Excel data is as easy as...
$sheet.SaveAs("taxrates.csv", 6) 
