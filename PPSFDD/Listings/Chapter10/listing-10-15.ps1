
Import-Module -Name umd_appconfig  #  Must call this to load configurations

Import-Module -Name umd_etl_functions

$Params = @{
    smtpServer = (Get-UdfConfiguation 'emailserver')
    from = (Get-UdfConfiguation 'emailfrom')
    to = (Get-UdfConfiguation 'edwteamemail')
    subject = 'Important Message'
    body = 'ETL Job executed'
    port = (Get-UdfConfiguation 'emailport')
    usecredential = ''
    emailaccount = (Get-UdfConfiguation 'emailaccount')
    password = (Get-UdfConfiguation 'emailpw')
}
Send-UdfMail @Params
    


