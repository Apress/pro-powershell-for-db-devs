USE AdventureWorks
GO

SELECT [DepartmentID]
      ,[Name]
      ,[GroupName]
      ,[ModifiedDate]
  FROM [HumanResources].[Department];

SELECT distinct DepartmentID
      ,[Name]
  FROM [HumanResources].[Department];

SELECT DepartmentID, [Name], GroupName, ModifiedDate
  FROM [HumanResources].[Department];
