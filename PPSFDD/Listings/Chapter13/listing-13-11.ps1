workflow Invoke-UdwWorkflowCommand {

 sequence 
 {
  "1"
  "2"
  "3"
 }

 parallel 
 {

   for($i=1; $i -le 100; $i++){ "a" }

   for($i=1; $i -le 100; $i++){ "b" }  

   for($i=1; $i -le 100; $i++){ "c" }

 }

  $collection = "one","two","three"

  foreach -parallel ($item in $collection)
  {
   "Length is: " + $item.Length 
  }

}

Invoke-UdwWorkflowCommand
