Import-Module umd_workflow -Force

$global:rootfilepath = $env:HOMEDRIVE + $env:HOMEPATH + '\documents\'

Register-UdfOrderFileCreateEvent $global:rootfilepath "orders.xml"  -sourceidentifier 'orders'

Register-UdfEmployeeFileCreateEvent $global:rootfilepath "Employees.txt" `
                                   -sourceidentifier 'employees'
