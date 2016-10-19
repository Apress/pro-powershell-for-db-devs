function Invoke-UdfProcessPipeline() {
  Begin {
    # Executes once, before the pipeline is loaded, i.e. $input is empty.
    "Begin block pipeline..." 
    $Input
  }

  Process {
    # Executes after pipeline is loaded, once for each item i.e. enumerates through each item in the collection.
   "Process block pipeline..."
   $Input
  }

  End {
    # Executes once after the Process block has finished.  Since there is a Process block, $input is emptied.
    "End block pipeline..."
    $Input
  }
} 

#  Pipe data into the function Invoke-UdfProcessPipeline
("A", "B", "C") | Invoke-UdfProcessPipeline
