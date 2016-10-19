function Find-NewMessages($valvar1, [REF]$refvar1, [REF]$refvar2) {
  #//some stuff
  $refvar1.Value = “hi”
  $refvar2.Value = “bye”
}

$refvar1 = “1”
$refvar2 = “2”
Find-NewMessages $valvar1 ([REF]$refvar1) ([REF]$refvar2) 