Import-Module -Name umd_etl_functions

$Params = @{
    smtpServer = $global:emailserver
    from = $global:emailfrom
    to = $global:edwteamemail
    subject = 'Important Message'
    body = 'ETL Job executed'
    port = $global:emailport
    usecredential = $true 
    emailaccount = $global:emailaccount
    password = $global:emailpw
}
Send-UdfMail @Params

