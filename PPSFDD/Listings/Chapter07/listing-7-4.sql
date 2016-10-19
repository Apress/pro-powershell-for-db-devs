USE [AdventureWorks]
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [HumanResources].[uspUpdateEmployeePersonalInfoPS]
    @BusinessEntityID [int], 
    @NationalIDNumber [nvarchar](15), 
    @BirthDate [datetime], 
    @MaritalStatus [nchar](1), 
    @Gender [nchar](1),
    @JobTitle [nvarchar](50) output,
    @HireDate [date] output,
    @VacationHours [smallint] output
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE [HumanResources].[Employee] 
        SET [NationalIDNumber] = @NationalIDNumber 
            ,[BirthDate] = @BirthDate 
            ,[MaritalStatus] = @MaritalStatus 
            ,[Gender] = @Gender 
        WHERE [BusinessEntityID] = @BusinessEntityID;

        select @JobTitle = JobTitle, @HireDate = HireDate, @VacationHours = VacationHours 
        from [HumanResources].[Employee] 
        where [BusinessEntityID] = @BusinessEntityID;

    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;

GO
