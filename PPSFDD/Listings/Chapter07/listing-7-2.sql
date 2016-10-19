Create PROCEDURE [HumanResources].[uspListEmployeePersonalInfoPS]
    @BusinessEntityID [int]
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

		select * 
		from [HumanResources].[Employee] 
		where [BusinessEntityID] = @BusinessEntityID;

    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;

GO
