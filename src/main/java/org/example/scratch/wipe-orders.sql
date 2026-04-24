DELETE FROM dbo.Feedbacks;
DELETE FROM dbo.OrderVouchers;
DELETE FROM dbo.OrderItems;
DELETE FROM dbo.Payments;
DELETE FROM dbo.Orders;

-- Reset Identity seeds so new orders start from 1
DBCC CHECKIDENT ('dbo.Orders', RESEED, 0);
DBCC CHECKIDENT ('dbo.Payments', RESEED, 0);
DBCC CHECKIDENT ('dbo.OrderItems', RESEED, 0);
DBCC CHECKIDENT ('dbo.Feedbacks', RESEED, 0);
GO
