workflow paralleltest {

 parallel 
 {

 for($i=1; $i -le 10000; $i++){ "a" }

 for($i=1; $i -le 10000; $i++){ "b" }  

 for($i=1; $i -le 10000; $i++){ "c" }

 for($i=1; $i -le 10000; $i++){ "d" }

 for($i=1; $i -le 10000; $i++){ "e" }

 }
}

paralleltest
