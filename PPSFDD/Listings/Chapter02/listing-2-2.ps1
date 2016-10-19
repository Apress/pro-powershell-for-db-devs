Set-Location $env:USERPROFILE
$streamin =  new-object System.IO.StreamReader("file1.txt")
$streamout = new-object System.IO.StreamWriter("file2.txt", 'Append')

[string] $inline = $streamin.ReadLine()

Do 
{
   if ($inline.Contains("stuff") ) 
     {
        $inline
        $streamout.WriteLine($inline) 
    }
     $inline=$streamin.ReadLine()
  }  Until ($streamin.EndOfStream) 

$streamout.Close()
$streamin.Close() 

