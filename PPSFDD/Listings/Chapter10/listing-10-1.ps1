# Some script
$global:myvar = 'global'   # All code in the session can access this.
"`$myvar is at the global scope - value is '$myvar'"

'Creating a new variable $myvar'
$myvar = 'script'   # Creates a new variable which hides the global variable.
"By default `$myvar is at the script scope - value is '$script:myvar'"

"We can still access the global variable using the scope prefix `$global:myvar - value is '$global:myvar'"

function Invoke-UdfSomething
{
  "Now in the function..."
  "`$myvar in the function sees the script scope - value is '$myvar'"

  # If we assign a value to $myvar we create a new variable in the function scope.
  'We assign a value to $myvar creating a function scoped variable'
  $myvar = 'function'

  "The default scope for `$myvar is now at the function level - value is '$myvar'"

  "within the function - can use scope prefix to see global variable `$global:myvar - is $global:myvar" 
  
  "within the function - can use scope prefix to see script variable `$script:myvar - is $script:myvar"
 
  "within the function - local scope is function - `$myvar is $myvar"

}

Invoke-UdfSomething  # Show variable scope in function

"Out of the function now..."
# Can we still access the global scope?
'We can still see the global scope...'
get-variable myvar -scope global
"`r`nAnd we can still see the script scope..."
get-variable myvar -scope script   # Local scope is script 
