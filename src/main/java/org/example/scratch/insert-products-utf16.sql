USE fresh_food_store;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

-- Variables to keep track of inserted IDs
DECLARE @Prod1 BIGINT, @Prod2 BIGINT, @Prod3 BIGINT;

-- Insert Product 1: Thịt bò Úc
INSERT INTO dbo.Products (categoryId, productName, description, imageUrl, basePriceAmount, priceBaseWeightGram, status)
VALUES (1, N'Thịt Bò Úc Nhập Khẩu', N'Thịt bò Úc thượng hạng, thích hợp làm steak và nướng BBQ.', N'/uploads/beef_australian.png', 300000.00, 1000, 1);
SET @Prod1 = SCOPE_IDENTITY();

-- Insert Product 2: Cá hồi Nauy
INSERT INTO dbo.Products (categoryId, productName, description, imageUrl, basePriceAmount, priceBaseWeightGram, status)
VALUES (1, N'Cá Hồi Nauy Phi Lê', N'Cá hồi tươi nhập khẩu trực tiếp bằng đường hàng không, giàu Omega-3.', N'https://bizweb.dktcdn.net/100/381/688/products/125d888f3-a6b1-4fca-b648-522dbef32943.jpg', 600000.00, 1000, 1);
SET @Prod2 = SCOPE_IDENTITY();

-- Insert Product 3: Sườn non heo
INSERT INTO dbo.Products (categoryId, productName, description, imageUrl, basePriceAmount, priceBaseWeightGram, status)
VALUES (1, N'Sườn Non Heo Tươi G.CP', N'Sườn non heo CP dán tem kiểm định đầy đủ, sụn mềm thịt ngọt.', N'https://cdn.tgdd.vn/Products/Images/8782/227181/bhx/suon-non-heo-dong-khay-500g-202102271638361730.jpeg', 180000.00, 1000, 1);
SET @Prod3 = SCOPE_IDENTITY();


-- Insert Product Packs for Product 1 (500g, 1kg)
INSERT INTO dbo.ProductPacks (productId, packWeightGram, sku, status) VALUES (@Prod1, 500, N'BEEF-AUC-05', 1);
INSERT INTO dbo.ProductPacks (productId, packWeightGram, sku, status) VALUES (@Prod1, 1000, N'BEEF-AUC-10', 1);

-- Insert Product Packs for Product 2 (300g, 500g)
INSERT INTO dbo.ProductPacks (productId, packWeightGram, sku, status) VALUES (@Prod2, 300, N'SALMON-300G', 1);
INSERT INTO dbo.ProductPacks (productId, packWeightGram, sku, status) VALUES (@Prod2, 500, N'SALMON-500G', 1);

-- Insert Product Packs for Product 3 (500g)
INSERT INTO dbo.ProductPacks (productId, packWeightGram, sku, status) VALUES (@Prod3, 500, N'PORKRIBS-500G', 1);

GO
