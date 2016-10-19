workflow Invoke-UdwForeachparallel
{ 

$collection = "one","two","three"

  foreach -parallel ($item in $collection)
  {
   "Length is: " + $item.Length 
  }
}

Invoke-UdwForeachparallel
