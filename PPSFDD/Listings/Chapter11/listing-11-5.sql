Create table dbo.Orders 
(
Order_ID       integer primary key,
Employee_ID    integer,
Order_Date     datetime,
Ship_City      varchar(150),
Ship_State     varchar(100), 
Status_ID      integer,
Customer_ID    integer,
Sales_Tax_Rate decimal(8,2)
)
