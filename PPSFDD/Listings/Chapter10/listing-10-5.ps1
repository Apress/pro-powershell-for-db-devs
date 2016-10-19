# Listing 10-5.  Calling Send-UdfMail using global configuration variables
Import-Module –Name umd_etl_functions

$Params = @{
    smtpServer = $global:psappconfig.emailserver
    from = $global:psappconfig.emailfrom
    to = $global:psappconfig.edwteamemail
    subject = 'Important Message'
    body = 'ETL Job executed'
    port = $global:psappconfig.emailport
    usecredential = $true 
    emailaccount = $global:psappconfig.emailaccount 
    password = $global:psappconfig.emailpw
}

Send-UdfMail @Params
  

