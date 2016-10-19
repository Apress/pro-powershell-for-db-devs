Import-Module "sqlps" 

$word = New-Object -ComObject Word.Application
$doc = $word.Documents.Add()

$stores = Invoke-Sqlcmd -Query "select top 10 * from [AdventureWorks].Sales.vStoreWithAddresses;" -QueryTimeout 3 

$outdoc = ""

foreach ($item in $stores) {
    $outdoc = $outdoc + $item.Name + "`r`n"
    $outdoc = $outdoc + $item.AddressLine1 + "`r`n"
    $outdoc = $outdoc + $item.City + ", " + $item.StateProvinceName + " " + $item.PostalCode + "`r`n"
    $outdoc = $outdoc + "`f"  # Does a page break
} 

$outtext = $doc.Content.Paragraphs.Add()
$outtext.Range.Text = $outdoc
$word.visible = $true 
