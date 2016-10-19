CREATE TABLE [dbo].[Customers](
	[Customer_ID] [int] NOT NULL,
	[Company_Name] [varchar](50) NULL,
	[First_Name] [varchar](50) NULL,
	[Last_Name] [varchar](50) NULL,
	[Title] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Zip] [varchar](15) NULL,
	[Country] [varchar](50) NULL,
	[State_Name] varchar(255) null,
	[State_Region] varchar(255) null 
PRIMARY KEY CLUSTERED 
(
	[Customer_ID] ASC
) )
