
#  Translate using machine default...
"Translating using default language..."
Import-LocalizedData -BindingVariable ds                                    # Machine Default - English

$ds.Sunday  
$ds.Monday  
$ds.Tuesday 
$ds.Wednesday  
$ds.Thursday 
$ds.Friday  
$ds.Saturday  

# Traslate to Spanish...
""
"Translating to Spain's Spanish..."
Import-LocalizedData -BindingVariable ds -UICulture es-ES                   # Machine Default - English

$ds.Sunday  
$ds.Monday  
$ds.Tuesday 
$ds.Wednesday  
$ds.Thursday 
$ds.Friday  
$ds.Saturday  

# Translate to German...
""
"Translating to Germany's German..."

Import-LocalizedData -BindingVariable ds -UICulture de-DE                    # Machine Default - English

$ds.Sunday  
$ds.Monday  
$ds.Tuesday 
$ds.Wednesday  
$ds.Thursday 
$ds.Friday  
$ds.Saturday  
