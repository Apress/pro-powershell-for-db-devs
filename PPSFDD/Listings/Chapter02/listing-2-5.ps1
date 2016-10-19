[string] $mystring = "  This is a nifty nifty string.  "

# Get a part of the string.
Write-Host $mystring.Substring(0,5) 

# Get the length of the string.
Write-Host $mystring.Length

# Comparing...
Write-Host $mystring.CompareTo("This is a nifty nifty string.")   # 0 = a match and -1 = no match.
Write-Host $mystring.Equals("This is a nifty string.")      # returns True or False

# Search for set of characters in the string.
Write-Host $mystring.Contains("nifty") # returns True or False

# Does the string end with the characters passed into the method?
Write-Host $mystring.EndsWith(".")   # returns True or False

# insert the set of characters in the second parameterstarting at the position specified in the first parameter.
Write-Host $mystring.Insert(5, "was ")   

# Convert to Upper Case
Write-Host $mystring.ToUpper()  

# Convert to Lower Case 
Write-Host $mystring.ToLower()  

# Strip off beginning and trailing spaces.
Write-Host $mystring.Trim() 

# Replace occurences of the set of characters specified in the first parameter with the set in the second parameter.
Write-Host $mystring.Replace("nifty", "swell")
