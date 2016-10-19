workflow myworkflow 
{
  sequence {
       "one"
       "two"
       "three"
     }

   parallel
   {
     
     "first parallel statement"
     Get-Date

   }

   $collection = "this","is","a","collection"

   foreach -parallel ($item in $collection)
   {
      $item
   }

   inlinescript { Get-ChildItem Env: }
}

myworkflow

#  See the workflow XAML definition...
(Get-Command myworkflow).XamlDefinition

# https://www.simple-talk.com/sysadmin/powershell/automating-day-to-day-powershell-admin-tasks---jobs-and-workflow/?utm_source=ssc&utm_medium=publink&utm_content=automatingpstasks

myworkflow -AsJob | Register-ScheduledJob -ScriptBlock {myworkflow} -Name BryWF1 -RunNow 

Get-Job -id 1

Get-ScheduledJob -Id 1

Receive-Job -ID 1 -Keep

Start-Job -DefinitionName BryWF1



