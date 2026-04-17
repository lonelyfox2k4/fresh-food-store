USE master;
GO

IF DB_ID(N'fresh_food_store') IS NOT NULL
BEGIN
    ALTER DATABASE fresh_food_store SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE fresh_food_store;
END
GO

CREATE DATABASE fresh_food_store;
GO

USE fresh_food_store;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO



CREATE TABLE dbo.Roles
(
    roleId INT IDENTITY(1,1) NOT NULL,
    roleName NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_Roles PRIMARY KEY (roleId),
    CONSTRAINT UQ_Roles_RoleName UNIQUE (roleName)
);
GO

CREATE TABLE dbo.Accounts
(
    accountId BIGINT IDENTITY(1,1) NOT NULL,
    roleId INT NOT NULL,
    email NVARCHAR(255) NOT NULL,
    passwordHash NVARCHAR(500) NULL,
    fullName NVARCHAR(255) NOT NULL,
    phone VARCHAR(30) NULL,
    status BIT NOT NULL CONSTRAINT DF_Accounts_Status DEFAULT (1),
    emailVerified BIT NOT NULL CONSTRAINT DF_Accounts_EmailVerified DEFAULT (0),
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_Accounts_CreatedAt DEFAULT SYSUTCDATETIME(),
    updatedAt DATETIME2(0) NULL,
    CONSTRAINT PK_Accounts PRIMARY KEY (accountId),
    CONSTRAINT UQ_Accounts_Email UNIQUE (email),
    CONSTRAINT FK_Accounts_Roles FOREIGN KEY (roleId) REFERENCES dbo.Roles(roleId)
);
GO

CREATE TABLE dbo.AccountGoogleLinks
(
    accountId BIGINT NOT NULL,
    googleUserId NVARCHAR(200) NOT NULL,
    googleEmail NVARCHAR(255) NOT NULL,
    linkedAt DATETIME2(0) NOT NULL CONSTRAINT DF_AccountGoogleLinks_LinkedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_AccountGoogleLinks PRIMARY KEY (accountId),
    CONSTRAINT UQ_AccountGoogleLinks_GoogleUserId UNIQUE (googleUserId),
    CONSTRAINT UQ_AccountGoogleLinks_GoogleEmail UNIQUE (googleEmail),
    CONSTRAINT FK_AccountGoogleLinks_Accounts FOREIGN KEY (accountId) REFERENCES dbo.Accounts(accountId)
);
GO

CREATE TABLE dbo.PasswordResetTokens
(
    resetTokenId BIGINT IDENTITY(1,1) NOT NULL,
    accountId BIGINT NOT NULL,
    tokenHash NVARCHAR(255) NOT NULL,
    expiresAt DATETIME2(0) NOT NULL,
    usedAt DATETIME2(0) NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_PasswordResetTokens_CreatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_PasswordResetTokens PRIMARY KEY (resetTokenId),
    CONSTRAINT UQ_PasswordResetTokens_TokenHash UNIQUE (tokenHash),
    CONSTRAINT FK_PasswordResetTokens_Accounts FOREIGN KEY (accountId) REFERENCES dbo.Accounts(accountId)
);
GO

CREATE TABLE dbo.Categories
(
    categoryId INT IDENTITY(1,1) NOT NULL,
    categoryName NVARCHAR(150) NOT NULL,
    status BIT NOT NULL CONSTRAINT DF_Categories_Status DEFAULT (1),
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_Categories_CreatedAt DEFAULT SYSUTCDATETIME(),
    updatedAt DATETIME2(0) NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (categoryId),
    CONSTRAINT UQ_Categories_CategoryName UNIQUE (categoryName)
);
GO

CREATE TABLE dbo.Suppliers
(
    supplierId BIGINT IDENTITY(1,1) NOT NULL,
    supplierName NVARCHAR(200) NOT NULL,
    phone VARCHAR(30) NULL,
    email NVARCHAR(255) NULL,
    address NVARCHAR(500) NULL,
    status BIT NOT NULL CONSTRAINT DF_Suppliers_Status DEFAULT (1),
    note NVARCHAR(1000) NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_Suppliers_CreatedAt DEFAULT SYSUTCDATETIME(),
    updatedAt DATETIME2(0) NULL,
    CONSTRAINT PK_Suppliers PRIMARY KEY (supplierId)
);
GO

CREATE TABLE dbo.ExpiryPricingPolicies
(
    policyId INT IDENTITY(1,1) NOT NULL,
    policyName NVARCHAR(150) NOT NULL,
    status BIT NOT NULL CONSTRAINT DF_ExpiryPricingPolicies_Status DEFAULT (1),
    note NVARCHAR(500) NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_ExpiryPricingPolicies_CreatedAt DEFAULT SYSUTCDATETIME(),
    createdById BIGINT NULL,
    updatedAt DATETIME2(0) NULL,
    updatedById BIGINT NULL,
    CONSTRAINT PK_ExpiryPricingPolicies PRIMARY KEY (policyId),
    CONSTRAINT UQ_ExpiryPricingPolicies_PolicyName UNIQUE (policyName),
    CONSTRAINT FK_ExpiryPricingPolicies_CreatedBy FOREIGN KEY (createdById) REFERENCES dbo.Accounts(accountId),
    CONSTRAINT FK_ExpiryPricingPolicies_UpdatedBy FOREIGN KEY (updatedById) REFERENCES dbo.Accounts(accountId)
);
GO

CREATE TABLE dbo.ExpiryPricingPolicyRules
(
    ruleId INT IDENTITY(1,1) NOT NULL,
    policyId INT NOT NULL,
    minDaysRemaining INT NOT NULL,
    sellPricePercent DECIMAL(5,2) NOT NULL,
    CONSTRAINT PK_ExpiryPricingPolicyRules PRIMARY KEY (ruleId),
    CONSTRAINT FK_ExpiryPricingPolicyRules_Policies FOREIGN KEY (policyId) REFERENCES dbo.ExpiryPricingPolicies(policyId),
    CONSTRAINT UQ_ExpiryPricingPolicyRules_Policy_MinDays UNIQUE (policyId, minDaysRemaining),
    CONSTRAINT CK_ExpiryPricingPolicyRules_MinDays CHECK (minDaysRemaining >= 0),
    CONSTRAINT CK_ExpiryPricingPolicyRules_SellPricePercent CHECK (sellPricePercent >= 0 AND sellPricePercent <= 100)
);
GO

CREATE TABLE dbo.Products
(
    productId BIGINT IDENTITY(1,1) NOT NULL,
    categoryId INT NOT NULL,
    productName NVARCHAR(200) NOT NULL,
    description NVARCHAR(MAX) NULL,
    imageUrl NVARCHAR(500) NULL,
    basePriceAmount DECIMAL(18,2) NOT NULL,
    priceBaseWeightGram INT NOT NULL,
    expiryPricingPolicyId INT NULL,
    status BIT NOT NULL CONSTRAINT DF_Products_Status DEFAULT (1),
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_Products_CreatedAt DEFAULT SYSUTCDATETIME(),
    updatedAt DATETIME2(0) NULL,
    CONSTRAINT PK_Products PRIMARY KEY (productId),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (categoryId) REFERENCES dbo.Categories(categoryId),
    CONSTRAINT FK_Products_ExpiryPricingPolicies FOREIGN KEY (expiryPricingPolicyId) REFERENCES dbo.ExpiryPricingPolicies(policyId),
    CONSTRAINT CK_Products_BasePriceAmount CHECK (basePriceAmount >= 0),
    CONSTRAINT CK_Products_PriceBaseWeightGram CHECK (priceBaseWeightGram > 0)
);
GO

CREATE TABLE dbo.ProductPacks
(
    productPackId BIGINT IDENTITY(1,1) NOT NULL,
    productId BIGINT NOT NULL,
    packWeightGram INT NOT NULL,
    sku NVARCHAR(100) NULL,
    status BIT NOT NULL CONSTRAINT DF_ProductPacks_Status DEFAULT (1),
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_ProductPacks_CreatedAt DEFAULT SYSUTCDATETIME(),
    updatedAt DATETIME2(0) NULL,
    CONSTRAINT PK_ProductPacks PRIMARY KEY (productPackId),
    CONSTRAINT FK_ProductPacks_Products FOREIGN KEY (productId) REFERENCES dbo.Products(productId),
    CONSTRAINT UQ_ProductPacks_Product_WeightGram UNIQUE (productId, packWeightGram),
    CONSTRAINT CK_ProductPacks_PackWeightGram CHECK (packWeightGram > 0)
);
GO

CREATE UNIQUE INDEX UX_ProductPacks_Sku
ON dbo.ProductPacks(sku)
WHERE sku IS NOT NULL;
GO

CREATE TABLE dbo.ProductPriceLogs
(
    priceLogId BIGINT IDENTITY(1,1) NOT NULL,
    productId BIGINT NOT NULL,
    oldBasePriceAmount DECIMAL(18,2) NOT NULL,
    newBasePriceAmount DECIMAL(18,2) NOT NULL,
    changedByAccountId BIGINT NOT NULL,
    changedAt DATETIME2(0) NOT NULL CONSTRAINT DF_ProductPriceLogs_ChangedAt DEFAULT SYSUTCDATETIME(),
    note NVARCHAR(500) NULL,
    CONSTRAINT PK_ProductPriceLogs PRIMARY KEY (priceLogId),
    CONSTRAINT FK_ProductPriceLogs_Products FOREIGN KEY (productId) REFERENCES dbo.Products(productId),
    CONSTRAINT FK_ProductPriceLogs_Accounts FOREIGN KEY (changedByAccountId) REFERENCES dbo.Accounts(accountId),
    CONSTRAINT CK_ProductPriceLogs_OldBasePriceAmount CHECK (oldBasePriceAmount >= 0),
    CONSTRAINT CK_ProductPriceLogs_NewBasePriceAmount CHECK (newBasePriceAmount >= 0)
);
GO

CREATE TABLE dbo.Discounts
(
    discountId BIGINT IDENTITY(1,1) NOT NULL,
    discountName NVARCHAR(150) NOT NULL,
    targetType TINYINT NOT NULL,
    productId BIGINT NULL,
    categoryId INT NULL,
    discountType TINYINT NOT NULL,
    discountValue DECIMAL(18,2) NOT NULL,
    startAt DATETIME2(0) NOT NULL,
    endAt DATETIME2(0) NOT NULL,
    status TINYINT NOT NULL,
    createdByAccountId BIGINT NOT NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_Discounts_CreatedAt DEFAULT SYSUTCDATETIME(),
    updatedAt DATETIME2(0) NULL,
    CONSTRAINT PK_Discounts PRIMARY KEY (discountId),
    CONSTRAINT FK_Discounts_Products FOREIGN KEY (productId) REFERENCES dbo.Products(productId),
    CONSTRAINT FK_Discounts_Categories FOREIGN KEY (categoryId) REFERENCES dbo.Categories(categoryId),
    CONSTRAINT FK_Discounts_CreatedByAccount FOREIGN KEY (createdByAccountId) REFERENCES dbo.Accounts(accountId),
    CONSTRAINT CK_Discounts_DiscountValue CHECK (discountValue >= 0),
    CONSTRAINT CK_Discounts_DateRange CHECK (endAt > startAt)
);
GO

CREATE TABLE dbo.Vouchers
(
    voucherId BIGINT IDENTITY(1,1) NOT NULL,
    voucherCode NVARCHAR(50) NOT NULL,
    voucherName NVARCHAR(150) NOT NULL,
    discountType TINYINT NOT NULL,
    discountValue DECIMAL(18,2) NOT NULL,
    minOrderAmount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Vouchers_MinOrderAmount DEFAULT (0),
    maxDiscountAmount DECIMAL(18,2) NULL,
    usageLimit INT NULL,
    usedCount INT NOT NULL CONSTRAINT DF_Vouchers_UsedCount DEFAULT (0),
    startAt DATETIME2(0) NOT NULL,
    endAt DATETIME2(0) NOT NULL,
    status TINYINT NOT NULL,
    createdByAccountId BIGINT NOT NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_Vouchers_CreatedAt DEFAULT SYSUTCDATETIME(),
    updatedAt DATETIME2(0) NULL,
    CONSTRAINT PK_Vouchers PRIMARY KEY (voucherId),
    CONSTRAINT UQ_Vouchers_VoucherCode UNIQUE (voucherCode),
    CONSTRAINT FK_Vouchers_CreatedByAccount FOREIGN KEY (createdByAccountId) REFERENCES dbo.Accounts(accountId),
    CONSTRAINT CK_Vouchers_DiscountValue CHECK (discountValue >= 0),
    CONSTRAINT CK_Vouchers_MinOrderAmount CHECK (minOrderAmount >= 0),
    CONSTRAINT CK_Vouchers_MaxDiscountAmount CHECK (maxDiscountAmount IS NULL OR maxDiscountAmount >= 0),
    CONSTRAINT CK_Vouchers_UsageLimit CHECK (usageLimit IS NULL OR usageLimit >= 0),
    CONSTRAINT CK_Vouchers_UsedCount CHECK (usedCount >= 0),
    CONSTRAINT CK_Vouchers_UsedCount_UsageLimit CHECK (usageLimit IS NULL OR usedCount <= usageLimit),
    CONSTRAINT CK_Vouchers_DateRange CHECK (endAt > startAt)
);
GO

CREATE TABLE dbo.VoucherRequests
(
    voucherRequestId BIGINT IDENTITY(1,1) NOT NULL,
    voucherId BIGINT NULL,
    accountId BIGINT NOT NULL,
    requestStatus TINYINT NOT NULL,
    requestNote NVARCHAR(500) NULL,
    reviewedByAccountId BIGINT NULL,
    requestedAt DATETIME2(0) NOT NULL CONSTRAINT DF_VoucherRequests_RequestedAt DEFAULT SYSUTCDATETIME(),
    reviewedAt DATETIME2(0) NULL,
    CONSTRAINT PK_VoucherRequests PRIMARY KEY (voucherRequestId),
    CONSTRAINT FK_VoucherRequests_Vouchers FOREIGN KEY (voucherId) REFERENCES dbo.Vouchers(voucherId),
    CONSTRAINT FK_VoucherRequests_Accounts FOREIGN KEY (accountId) REFERENCES dbo.Accounts(accountId),
    CONSTRAINT FK_VoucherRequests_ReviewedByAccount FOREIGN KEY (reviewedByAccountId) REFERENCES dbo.Accounts(accountId)
);
GO

CREATE TABLE dbo.Carts
(
    cartId BIGINT IDENTITY(1,1) NOT NULL,
    accountId BIGINT NOT NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_Carts_CreatedAt DEFAULT SYSUTCDATETIME(),
    updatedAt DATETIME2(0) NULL,
    CONSTRAINT PK_Carts PRIMARY KEY (cartId),
    CONSTRAINT UQ_Carts_Account UNIQUE (accountId),
    CONSTRAINT FK_Carts_Accounts FOREIGN KEY (accountId) REFERENCES dbo.Accounts(accountId)
);
GO

CREATE TABLE dbo.CartItems
(
    cartItemId BIGINT IDENTITY(1,1) NOT NULL,
    cartId BIGINT NOT NULL,
    productPackId BIGINT NOT NULL,
    quantity INT NOT NULL,
    addedAt DATETIME2(0) NOT NULL CONSTRAINT DF_CartItems_AddedAt DEFAULT SYSUTCDATETIME(),
    updatedAt DATETIME2(0) NULL,
    CONSTRAINT PK_CartItems PRIMARY KEY (cartItemId),
    CONSTRAINT FK_CartItems_Carts FOREIGN KEY (cartId) REFERENCES dbo.Carts(cartId),
    CONSTRAINT FK_CartItems_ProductPacks FOREIGN KEY (productPackId) REFERENCES dbo.ProductPacks(productPackId),
    CONSTRAINT UQ_CartItems_Cart_ProductPack UNIQUE (cartId, productPackId),
    CONSTRAINT CK_CartItems_Quantity CHECK (quantity > 0)
);
GO

CREATE TABLE dbo.GoodsReceipts
(
    receiptId BIGINT IDENTITY(1,1) NOT NULL,
    receiptCode NVARCHAR(50) NOT NULL,
    supplierId BIGINT NOT NULL,
    receivedByAccountId BIGINT NOT NULL,
    receivedAt DATETIME2(0) NOT NULL,
    status TINYINT NOT NULL,
    note NVARCHAR(1000) NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_GoodsReceipts_CreatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_GoodsReceipts PRIMARY KEY (receiptId),
    CONSTRAINT UQ_GoodsReceipts_ReceiptCode UNIQUE (receiptCode),
    CONSTRAINT FK_GoodsReceipts_Suppliers FOREIGN KEY (supplierId) REFERENCES dbo.Suppliers(supplierId),
    CONSTRAINT FK_GoodsReceipts_ReceivedByAccount FOREIGN KEY (receivedByAccountId) REFERENCES dbo.Accounts(accountId)
);
GO

CREATE TABLE dbo.GoodsReceiptItems
(
    receiptItemId BIGINT IDENTITY(1,1) NOT NULL,
    receiptId BIGINT NOT NULL,
    productPackId BIGINT NOT NULL,
    batchCode NVARCHAR(100) NOT NULL,
    manufactureDate DATE NULL,
    expiryDate DATE NOT NULL,
    quantityReceived INT NOT NULL,
    unitCost DECIMAL(18,2) NOT NULL,
    note NVARCHAR(500) NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_GoodsReceiptItems_CreatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_GoodsReceiptItems PRIMARY KEY (receiptItemId),
    CONSTRAINT UQ_GoodsReceiptItems_BatchCode UNIQUE (batchCode),
    CONSTRAINT FK_GoodsReceiptItems_GoodsReceipts FOREIGN KEY (receiptId) REFERENCES dbo.GoodsReceipts(receiptId),
    CONSTRAINT FK_GoodsReceiptItems_ProductPacks FOREIGN KEY (productPackId) REFERENCES dbo.ProductPacks(productPackId),
    CONSTRAINT CK_GoodsReceiptItems_QuantityReceived CHECK (quantityReceived > 0),
    CONSTRAINT CK_GoodsReceiptItems_UnitCost CHECK (unitCost >= 0),
    CONSTRAINT CK_GoodsReceiptItems_ExpiryDate CHECK (manufactureDate IS NULL OR expiryDate >= manufactureDate)
);
GO

CREATE TABLE dbo.InventoryBatches
(
    batchId BIGINT IDENTITY(1,1) NOT NULL,
    receiptItemId BIGINT NOT NULL,
    quantityOnHand INT NOT NULL,
    quantityReserved INT NOT NULL CONSTRAINT DF_InventoryBatches_QuantityReserved DEFAULT (0),
    status TINYINT NOT NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_InventoryBatches_CreatedAt DEFAULT SYSUTCDATETIME(),
    updatedAt DATETIME2(0) NULL,
    CONSTRAINT PK_InventoryBatches PRIMARY KEY (batchId),
    CONSTRAINT UQ_InventoryBatches_ReceiptItem UNIQUE (receiptItemId),
    CONSTRAINT FK_InventoryBatches_GoodsReceiptItems FOREIGN KEY (receiptItemId) REFERENCES dbo.GoodsReceiptItems(receiptItemId),
    CONSTRAINT CK_InventoryBatches_QuantityOnHand CHECK (quantityOnHand >= 0),
    CONSTRAINT CK_InventoryBatches_QuantityReserved CHECK (quantityReserved >= 0 AND quantityReserved <= quantityOnHand)
);
GO

CREATE TABLE dbo.InventoryTransactions
(
    inventoryTransactionId BIGINT IDENTITY(1,1) NOT NULL,
    batchId BIGINT NOT NULL,
    transactionType TINYINT NOT NULL,
    quantity INT NOT NULL,
    referenceType NVARCHAR(30) NULL,
    referenceId BIGINT NULL,
    performedByAccountId BIGINT NULL,
    note NVARCHAR(500) NULL,
    transactionAt DATETIME2(0) NOT NULL CONSTRAINT DF_InventoryTransactions_TransactionAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_InventoryTransactions PRIMARY KEY (inventoryTransactionId),
    CONSTRAINT FK_InventoryTransactions_InventoryBatches FOREIGN KEY (batchId) REFERENCES dbo.InventoryBatches(batchId),
    CONSTRAINT FK_InventoryTransactions_PerformedByAccount FOREIGN KEY (performedByAccountId) REFERENCES dbo.Accounts(accountId),
    CONSTRAINT CK_InventoryTransactions_Quantity CHECK (quantity <> 0)
);
GO

CREATE TABLE dbo.Orders
(
    orderId BIGINT IDENTITY(1,1) NOT NULL,
    orderCode NVARCHAR(50) NOT NULL,
    accountId BIGINT NOT NULL,
    shipperId BIGINT NULL,
    orderStatus TINYINT NOT NULL,
    paymentStatus TINYINT NOT NULL,
    shippingStatus TINYINT NULL,
    subtotalAmount DECIMAL(18,2) NOT NULL,
    discountAmount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Orders_DiscountAmount DEFAULT (0),
    shippingFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_Orders_ShippingFee DEFAULT (0),
    totalAmount DECIMAL(18,2) NOT NULL,
    recipientNameSnapshot NVARCHAR(150) NOT NULL,
    recipientPhoneSnapshot VARCHAR(30) NOT NULL,
    shippingAddressSnapshot NVARCHAR(500) NULL,
    note NVARCHAR(1000) NULL,
    placedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Orders_PlacedAt DEFAULT SYSUTCDATETIME(),
    paidAt DATETIME2(0) NULL,
    cancelledAt DATETIME2(0) NULL,
    cancelledReason NVARCHAR(500) NULL,
    CONSTRAINT PK_Orders PRIMARY KEY (orderId),
    CONSTRAINT UQ_Orders_OrderCode UNIQUE (orderCode),
    CONSTRAINT FK_Orders_Accounts FOREIGN KEY (accountId) REFERENCES dbo.Accounts(accountId),
    CONSTRAINT FK_Orders_Shippers FOREIGN KEY (shipperId) REFERENCES dbo.Accounts(accountId),
    CONSTRAINT CK_Orders_SubtotalAmount CHECK (subtotalAmount >= 0),
    CONSTRAINT CK_Orders_DiscountAmount CHECK (discountAmount >= 0),
    CONSTRAINT CK_Orders_ShippingFee CHECK (shippingFee >= 0),
    CONSTRAINT CK_Orders_TotalAmount CHECK (totalAmount >= 0)
);
GO

CREATE TABLE dbo.OrderItems
(
    orderItemId BIGINT IDENTITY(1,1) NOT NULL,
    orderId BIGINT NOT NULL,
    productId BIGINT NOT NULL,
    productPackId BIGINT NULL,
    productNameSnapshot NVARCHAR(200) NOT NULL,
    packWeightGramSnapshot INT NOT NULL,
    imageUrlSnapshot NVARCHAR(500) NULL,
    computedPackBasePriceSnapshot DECIMAL(18,2) NOT NULL,
    orderedQuantity INT NOT NULL,
    lineSubtotalSnapshot DECIMAL(18,2) NOT NULL,
    lineDiscountSnapshot DECIMAL(18,2) NOT NULL CONSTRAINT DF_OrderItems_LineDiscountSnapshot DEFAULT (0),
    lineTotalSnapshot DECIMAL(18,2) NOT NULL,
    CONSTRAINT PK_OrderItems PRIMARY KEY (orderItemId),
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (orderId) REFERENCES dbo.Orders(orderId),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (productId) REFERENCES dbo.Products(productId),
    CONSTRAINT FK_OrderItems_ProductPacks FOREIGN KEY (productPackId) REFERENCES dbo.ProductPacks(productPackId),
    CONSTRAINT CK_OrderItems_PackWeightGramSnapshot CHECK (packWeightGramSnapshot > 0),
    CONSTRAINT CK_OrderItems_ComputedPackBasePriceSnapshot CHECK (computedPackBasePriceSnapshot >= 0),
    CONSTRAINT CK_OrderItems_OrderedQuantity CHECK (orderedQuantity > 0),
    CONSTRAINT CK_OrderItems_LineSubtotalSnapshot CHECK (lineSubtotalSnapshot >= 0),
    CONSTRAINT CK_OrderItems_LineDiscountSnapshot CHECK (lineDiscountSnapshot >= 0),
    CONSTRAINT CK_OrderItems_LineTotalSnapshot CHECK (lineTotalSnapshot >= 0)
);
GO

CREATE TABLE dbo.OrderItemAllocations
(
    allocationId BIGINT IDENTITY(1,1) NOT NULL,
    orderItemId BIGINT NOT NULL,
    batchId BIGINT NOT NULL,
    batchCodeSnapshot NVARCHAR(100) NOT NULL,
    expiryDateSnapshot DATE NOT NULL,
    quantity INT NOT NULL,
    basePackPriceSnapshot DECIMAL(18,2) NOT NULL,
    sellPricePercentSnapshot DECIMAL(5,2) NOT NULL,
    finalPackPriceSnapshot DECIMAL(18,2) NOT NULL,
    lineTotalSnapshot DECIMAL(18,2) NOT NULL,
    CONSTRAINT PK_OrderItemAllocations PRIMARY KEY (allocationId),
    CONSTRAINT FK_OrderItemAllocations_OrderItems FOREIGN KEY (orderItemId) REFERENCES dbo.OrderItems(orderItemId),
    CONSTRAINT FK_OrderItemAllocations_InventoryBatches FOREIGN KEY (batchId) REFERENCES dbo.InventoryBatches(batchId),
    CONSTRAINT CK_OrderItemAllocations_Quantity CHECK (quantity > 0),
    CONSTRAINT CK_OrderItemAllocations_BasePackPriceSnapshot CHECK (basePackPriceSnapshot >= 0),
    CONSTRAINT CK_OrderItemAllocations_SellPricePercentSnapshot CHECK (sellPricePercentSnapshot >= 0 AND sellPricePercentSnapshot <= 100),
    CONSTRAINT CK_OrderItemAllocations_FinalPackPriceSnapshot CHECK (finalPackPriceSnapshot >= 0),
    CONSTRAINT CK_OrderItemAllocations_LineTotalSnapshot CHECK (lineTotalSnapshot >= 0)
);
GO

CREATE TABLE dbo.Payments
(
    paymentId BIGINT IDENTITY(1,1) NOT NULL,
    orderId BIGINT NOT NULL,
    provider NVARCHAR(30) NOT NULL,
    amount DECIMAL(18,2) NOT NULL,
    paymentStatus TINYINT NOT NULL,
    gatewayTransactionId NVARCHAR(150) NULL,
    gatewayOrderRef NVARCHAR(150) NULL,
    paymentUrl NVARCHAR(1000) NULL,
    requestedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Payments_RequestedAt DEFAULT SYSUTCDATETIME(),
    paidAt DATETIME2(0) NULL,
    failedAt DATETIME2(0) NULL,
    rawResponse NVARCHAR(MAX) NULL,
    CONSTRAINT PK_Payments PRIMARY KEY (paymentId),
    CONSTRAINT FK_Payments_Orders FOREIGN KEY (orderId) REFERENCES dbo.Orders(orderId),
    CONSTRAINT CK_Payments_Amount CHECK (amount >= 0)
);
GO

CREATE UNIQUE INDEX UX_Payments_GatewayTransactionId
ON dbo.Payments(gatewayTransactionId)
WHERE gatewayTransactionId IS NOT NULL;
GO

CREATE TABLE dbo.OrderVouchers
(
    orderVoucherId BIGINT IDENTITY(1,1) NOT NULL,
    orderId BIGINT NOT NULL,
    voucherId BIGINT NULL,
    voucherCodeSnapshot NVARCHAR(50) NOT NULL,
    discountAmountSnapshot DECIMAL(18,2) NOT NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_OrderVouchers_CreatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_OrderVouchers PRIMARY KEY (orderVoucherId),
    CONSTRAINT FK_OrderVouchers_Orders FOREIGN KEY (orderId) REFERENCES dbo.Orders(orderId),
    CONSTRAINT FK_OrderVouchers_Vouchers FOREIGN KEY (voucherId) REFERENCES dbo.Vouchers(voucherId),
    CONSTRAINT CK_OrderVouchers_DiscountAmountSnapshot CHECK (discountAmountSnapshot >= 0)
);
GO

CREATE TABLE dbo.ProductReviews
(
    reviewId BIGINT IDENTITY(1,1) NOT NULL,
    productId BIGINT NOT NULL,
    accountId BIGINT NOT NULL,
    sourceOrderItemId BIGINT NULL,
    rating TINYINT NOT NULL,
    comment NVARCHAR(1000) NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_ProductReviews_CreatedAt DEFAULT SYSUTCDATETIME(),
    updatedAt DATETIME2(0) NULL,
    CONSTRAINT PK_ProductReviews PRIMARY KEY (reviewId),
    CONSTRAINT FK_ProductReviews_Products FOREIGN KEY (productId) REFERENCES dbo.Products(productId),
    CONSTRAINT FK_ProductReviews_Accounts FOREIGN KEY (accountId) REFERENCES dbo.Accounts(accountId),
    CONSTRAINT FK_ProductReviews_OrderItems FOREIGN KEY (sourceOrderItemId) REFERENCES dbo.OrderItems(orderItemId),
    CONSTRAINT CK_ProductReviews_Rating CHECK (rating BETWEEN 1 AND 5)
);
GO

CREATE TABLE dbo.Wishlists
(
    wishlistId BIGINT IDENTITY(1,1) NOT NULL,
    accountId BIGINT NOT NULL,
    productId BIGINT NOT NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_Wishlists_CreatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Wishlists PRIMARY KEY (wishlistId),
    CONSTRAINT FK_Wishlists_Accounts FOREIGN KEY (accountId) REFERENCES dbo.Accounts(accountId),
    CONSTRAINT FK_Wishlists_Products FOREIGN KEY (productId) REFERENCES dbo.Products(productId),
    CONSTRAINT UQ_Wishlists_Account_Product UNIQUE (accountId, productId)
);
GO

CREATE TABLE dbo.Feedbacks
(
    feedbackId BIGINT IDENTITY(1,1) NOT NULL,
    accountId BIGINT NOT NULL,
    orderId BIGINT NULL,
    subject NVARCHAR(200) NULL,
    content NVARCHAR(1000) NOT NULL,
    response NVARCHAR(1000) NULL,
    status TINYINT NOT NULL,
    respondedByAccountId BIGINT NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_Feedbacks_CreatedAt DEFAULT SYSUTCDATETIME(),
    respondedAt DATETIME2(0) NULL,
    updatedAt DATETIME2(0) NULL,
    CONSTRAINT PK_Feedbacks PRIMARY KEY (feedbackId),
    CONSTRAINT FK_Feedbacks_Accounts FOREIGN KEY (accountId) REFERENCES dbo.Accounts(accountId),
    CONSTRAINT FK_Feedbacks_Orders FOREIGN KEY (orderId) REFERENCES dbo.Orders(orderId),
    CONSTRAINT FK_Feedbacks_RespondedByAccount FOREIGN KEY (respondedByAccountId) REFERENCES dbo.Accounts(accountId)
);
GO

CREATE TABLE dbo.NewsArticles
(
    newsId BIGINT IDENTITY(1,1) NOT NULL,
    title NVARCHAR(200) NOT NULL,
    summary NVARCHAR(500) NULL,
    content NVARCHAR(MAX) NOT NULL,
    imageUrl NVARCHAR(500) NULL,
    status TINYINT NOT NULL,
    createdByAccountId BIGINT NOT NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_NewsArticles_CreatedAt DEFAULT SYSUTCDATETIME(),
    updatedAt DATETIME2(0) NULL,
    publishedAt DATETIME2(0) NULL,
    CONSTRAINT PK_NewsArticles PRIMARY KEY (newsId),
    CONSTRAINT FK_NewsArticles_CreatedByAccount FOREIGN KEY (createdByAccountId) REFERENCES dbo.Accounts(accountId)
);
GO

CREATE TABLE dbo.AboutContents
(
    aboutContentId BIGINT IDENTITY(1,1) NOT NULL,
    sectionKey NVARCHAR(100) NOT NULL,
    title NVARCHAR(200) NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    imageUrl NVARCHAR(500) NULL,
    status BIT NOT NULL CONSTRAINT DF_AboutContents_Status DEFAULT (1),
    updatedByAccountId BIGINT NULL,
    updatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_AboutContents_UpdatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_AboutContents PRIMARY KEY (aboutContentId),
    CONSTRAINT UQ_AboutContents_SectionKey UNIQUE (sectionKey),
    CONSTRAINT FK_AboutContents_UpdatedByAccount FOREIGN KEY (updatedByAccountId) REFERENCES dbo.Accounts(accountId)
);
GO

CREATE TABLE dbo.ChatConversations
(
    conversationId BIGINT IDENTITY(1,1) NOT NULL,
    customerId BIGINT NOT NULL,
    assignedStaffId BIGINT NULL,
    status TINYINT NOT NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_ChatConversations_CreatedAt DEFAULT SYSUTCDATETIME(),
    updatedAt DATETIME2(0) NULL,
    closedAt DATETIME2(0) NULL,
    CONSTRAINT PK_ChatConversations PRIMARY KEY (conversationId),
    CONSTRAINT FK_ChatConversations_Customers FOREIGN KEY (customerId) REFERENCES dbo.Accounts(accountId),
    CONSTRAINT FK_ChatConversations_AssignedStaff FOREIGN KEY (assignedStaffId) REFERENCES dbo.Accounts(accountId)
);
GO

CREATE TABLE dbo.ChatMessages
(
    messageId BIGINT IDENTITY(1,1) NOT NULL,
    conversationId BIGINT NOT NULL,
    senderAccountId BIGINT NOT NULL,
    messageText NVARCHAR(1000) NOT NULL,
    messageType TINYINT NOT NULL CONSTRAINT DF_ChatMessages_MessageType DEFAULT (1),
    isRead BIT NOT NULL CONSTRAINT DF_ChatMessages_IsRead DEFAULT (0),
    sentAt DATETIME2(0) NOT NULL CONSTRAINT DF_ChatMessages_SentAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_ChatMessages PRIMARY KEY (messageId),
    CONSTRAINT FK_ChatMessages_Conversations FOREIGN KEY (conversationId) REFERENCES dbo.ChatConversations(conversationId),
    CONSTRAINT FK_ChatMessages_SenderAccounts FOREIGN KEY (senderAccountId) REFERENCES dbo.Accounts(accountId)
);
GO

CREATE INDEX IX_Accounts_RoleId ON dbo.Accounts(roleId);
CREATE INDEX IX_PasswordResetTokens_AccountId ON dbo.PasswordResetTokens(accountId);
CREATE INDEX IX_Products_Category_Status ON dbo.Products(categoryId, status);
CREATE INDEX IX_ProductPacks_ProductId ON dbo.ProductPacks(productId);
CREATE INDEX IX_ProductPriceLogs_Product_ChangedAt ON dbo.ProductPriceLogs(productId, changedAt DESC);
CREATE INDEX IX_Discounts_Product_Status_Date ON dbo.Discounts(productId, status, startAt, endAt);
CREATE INDEX IX_Discounts_Category_Status_Date ON dbo.Discounts(categoryId, status, startAt, endAt);
CREATE INDEX IX_Vouchers_Status_Date ON dbo.Vouchers(status, startAt, endAt);
CREATE INDEX IX_VoucherRequests_Account_Status ON dbo.VoucherRequests(accountId, requestStatus);
CREATE INDEX IX_CartItems_ProductPackId ON dbo.CartItems(productPackId);
CREATE INDEX IX_GoodsReceipts_Supplier_ReceivedAt ON dbo.GoodsReceipts(supplierId, receivedAt DESC);
CREATE INDEX IX_GoodsReceiptItems_ProductPack_ExpiryDate ON dbo.GoodsReceiptItems(productPackId, expiryDate);
CREATE INDEX IX_InventoryBatches_Status ON dbo.InventoryBatches(status);
CREATE INDEX IX_InventoryTransactions_Batch_TransactionAt ON dbo.InventoryTransactions(batchId, transactionAt DESC);
CREATE INDEX IX_Orders_Account_PlacedAt ON dbo.Orders(accountId, placedAt DESC);
CREATE INDEX IX_Orders_Shipper_Status ON dbo.Orders(shipperId, orderStatus);
CREATE INDEX IX_OrderItems_OrderId ON dbo.OrderItems(orderId);
CREATE INDEX IX_OrderItems_ProductId ON dbo.OrderItems(productId);
CREATE INDEX IX_OrderItemAllocations_OrderItemId ON dbo.OrderItemAllocations(orderItemId);
CREATE INDEX IX_OrderItemAllocations_BatchId ON dbo.OrderItemAllocations(batchId);
CREATE INDEX IX_Payments_OrderId ON dbo.Payments(orderId);
CREATE INDEX IX_OrderVouchers_OrderId ON dbo.OrderVouchers(orderId);
CREATE INDEX IX_ProductReviews_ProductId ON dbo.ProductReviews(productId);
CREATE INDEX IX_Feedbacks_Account_Status ON dbo.Feedbacks(accountId, status);
CREATE INDEX IX_NewsArticles_Status_PublishedAt ON dbo.NewsArticles(status, publishedAt DESC);
CREATE INDEX IX_ChatConversations_Customer_Status ON dbo.ChatConversations(customerId, status);
CREATE INDEX IX_ChatConversations_AssignedStaff_Status ON dbo.ChatConversations(assignedStaffId, status);
CREATE INDEX IX_ChatMessages_Conversation_SentAt ON dbo.ChatMessages(conversationId, sentAt);
GO

DBCC CHECKIDENT ('dbo.Roles', RESEED, 0);

SET IDENTITY_INSERT dbo.Roles ON;

INSERT INTO dbo.Roles (roleId, roleName) VALUES (1, N'Admin');
INSERT INTO dbo.Roles (roleId, roleName) VALUES (2, N'Manager');
INSERT INTO dbo.Roles (roleId, roleName) VALUES (3, N'Staff');
INSERT INTO dbo.Roles (roleId, roleName) VALUES (4, N'Shipper');
INSERT INTO dbo.Roles (roleId, roleName) VALUES (5, N'Customer');

SET IDENTITY_INSERT dbo.Roles OFF;
GO
