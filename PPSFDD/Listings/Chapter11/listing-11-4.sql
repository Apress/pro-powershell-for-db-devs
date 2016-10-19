CREATE TABLE [dbo].[Products](
	[SupplierIDs] [nvarchar](max) NULL,
	[ID] [int] NOT NULL,
	[ProductCode] [nvarchar](25) NULL,
	[ProductName] [nvarchar](50) NULL,
	[Description] [nvarchar](max) NULL,
	[StandardCost] [money] NULL,
	[ListPrice] [money] NOT NULL,
	[ReorderLevel] [smallint] NULL,
	[TargetLevel] [int] NULL,
	[QuantityPerUnit] [nvarchar](50) NULL,
	[Discontinued] [varchar](5) NOT NULL,
	[MinimumReorderQuantity] [smallint] NULL,
	[Category] [nvarchar](50) NULL,
	[Attachments] [nvarchar](max) NULL
) 
