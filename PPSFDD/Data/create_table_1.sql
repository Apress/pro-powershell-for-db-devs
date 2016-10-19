/*

Author:  Bryan Cafferky     Date: 2014-03-11

Purpose:  Staging table to hold Core Eligibiity data.

*/

If Object_ID('dbo.Table1') is not null
    begin
        drop table dbo.Table1
		Print 'Table dbo.Table1 found and dropped...'
   end;

CREATE TABLE dbo.table1
(
     id                                                            integer identity(1,1)  not null PRIMARY KEY CLUSTERED,
	 field1                                                        varchar(50)   NULL,
     field2                                                        varchar(50)  NULL
)
	


