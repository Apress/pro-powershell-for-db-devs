function Invoke-UdfProcessPipelineEndBlockReset() {
  Begin {
    # Executes before the pipeline is loaded, i.e. $input is empty.
    "Begin block pipeline..." 
    $Input
  }

  End {
    # Since the Process block
    "End block pipeline..."  
    "Iterate through first time to process..."
    $Input | ForEach-Object {$_}
    $Input.Reset()
    "Show the pipeline has been reset by listing it again..."
    $Input
  }
} 

#  Pipe data into the function Invoke-UdfProcessPipeline
("A", "B", "C") | Invoke-UdfProcessPipelineEndBlockReset 
