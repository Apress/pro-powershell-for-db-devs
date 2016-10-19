insert into [dbo].PSAppConfig (Project, [Name], [Value]) 
Values ('general','edwserver','(local)');

insert into [dbo].PSAppConfig (Project, [Name], [Value]) 
Values ('general','emailserver','smtp.live.com');

insert into [dbo].PSAppConfig (Project, [Name], [Value]) 
Values ('general','ftppath','\\ftpserver\ftp\');

insert into [dbo].PSAppConfig (Project, [Name], [Value]) 
Values ('edw','teamemail','edwteamdist');

insert into [dbo].PSAppConfig (Project, [Name], [Value]) 
Values ('edw','stagingdb','staging');

insert into [dbo].PSAppConfig (Project, [Name], [Value]) 
Values ('finance','ftppath','\\financeftpserver\ftp\');

insert into [dbo].PSAppConfig (Project, [Name], [Value]) 
Values ('finance','dbserver','financesqlsvr');

insert into [dbo].PSAppConfig (Project, [Name], [Value]) 
Values ('finance','outfolder','\\somepath\outdata\');
