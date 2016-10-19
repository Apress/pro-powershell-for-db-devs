Use AdventureWorks
go

Declare @JobTitle     	 	[nvarchar](50) 
Declare	@HireDate        	[date] 
Declare	@VacationHours   	[smallint] 

exec  [HumanResources].[uspUpdateEmployeePersonalInfoPS] 1, 295847284, '1963-01-01', 'M', 'M',  @JobTitle Output, @HireDate Output, @VacationHours Output

print  @JobTitle 
print  @HireDate
print  @VacationHours
