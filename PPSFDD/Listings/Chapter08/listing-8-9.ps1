$DebugPreference = "SilentlyContinue"

function Show-UdfMyDebugMessage {
[CmdletBinding()]
        param ()

  Write-Debug "Debug message"

  $DebugPreference

  Write-Debug "2nd Debug message"

}

# Call without Debug switch
Show-UdfMyDebugMessage 

# Call with Debug switch
Show-UdfMyDebugMessage -Debug
