CREATE TABLE [HumanResources].[CompanyUnit](
	[UnitID] [smallint]  NOT NULL,
	[UnitName] [dbo].[Name] NOT NULL,
	[UnitGroupName] [dbo].[Name] NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_DepartmentNew_UnitID] PRIMARY KEY CLUSTERED 
(
	[UnitID] ASC
) )
Go

insert into  [HumanResources].[CompanyUnit]
select * from [HumanResources].[Department]
go
