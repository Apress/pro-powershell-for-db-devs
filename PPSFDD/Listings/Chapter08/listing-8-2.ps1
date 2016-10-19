function Invoke-UdfProcessPipelineEndBlock() {
  Begin {
    # Executes before the pipeline is loaded, i.e. $input is empty.
    "Begin block pipeline..." 
    $Input
  }

  #  No process block.

  End {
    # Since the Process block
    "End block pipeline..."
    $Input
  }
} 

#  Pipe data into the function Invoke-UdfProcessPipeline
("A", "B", "C") | Invoke-UdfProcessPipelineEndBlock
