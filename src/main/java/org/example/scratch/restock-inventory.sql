USE fresh_food_store;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

-- 1. Ensure supplier exists
IF NOT EXISTS (SELECT 1 FROM dbo.Suppliers)
BEGIN
    INSERT INTO dbo.Suppliers (supplierName, status) VALUES (N'Nhà Cung Cấp Tổng', 1);
END
DECLARE @SupplierId BIGINT = (SELECT TOP 1 supplierId FROM dbo.Suppliers);

-- 2. Create GoodsReceipt
DECLARE @ReceiptCode NVARCHAR(50) = N'RC-' + CAST(DATEDIFF(s, '1970-01-01', GETUTCDATE()) AS NVARCHAR);
INSERT INTO dbo.GoodsReceipts (receiptCode, supplierId, receivedByAccountId, receivedAt, status, note)
VALUES (@ReceiptCode, @SupplierId, 1, GETUTCDATE(), 1, N'Nhập hàng tự động để test');
DECLARE @ReceiptId BIGINT = SCOPE_IDENTITY();

-- 3. Loop through all ProductPacks and insert
DECLARE @PackId BIGINT;
DECLARE pack_cursor CURSOR FOR SELECT productPackId FROM dbo.ProductPacks;
OPEN pack_cursor;
FETCH NEXT FROM pack_cursor INTO @PackId;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Create GoodsReceiptItem
    DECLARE @BatchCode NVARCHAR(100) = N'BATCH-' + CAST(@PackId AS NVARCHAR) + '-' + CAST(DATEDIFF(s, '1970-01-01', GETUTCDATE()) AS NVARCHAR);
    INSERT INTO dbo.GoodsReceiptItems (receiptId, productPackId, batchCode, expiryDate, quantityReceived, unitCost)
    VALUES (@ReceiptId, @PackId, @BatchCode, DATEADD(day, 30, GETDATE()), 100, 100000);
    
    DECLARE @ReceiptItemId BIGINT = SCOPE_IDENTITY();
    
    -- Create InventoryBatch with 100 stock
    INSERT INTO dbo.InventoryBatches (receiptItemId, quantityOnHand, quantityReserved, status)
    VALUES (@ReceiptItemId, 100, 0, 1);

    FETCH NEXT FROM pack_cursor INTO @PackId;
END

CLOSE pack_cursor;
DEALLOCATE pack_cursor;
GO
