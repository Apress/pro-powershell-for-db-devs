CREATE TABLE [dbo].PSAppConfig
(
	[Project]     varchar(50),
	[Name]        varchar(100),
	[Value]       varchar(100),
	[CreateDate]  datetime  default(getdate()),
	[UpdateDate]  datetime  default(getdate()),
	Primary Key (Project, Name)
) 
