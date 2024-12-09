create database db7
use db7

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Items](
	[ItemNo] [int] NOT NULL,
	[Name] [varchar](10) NULL,
	[Price] [int] NULL,
	[Quantity in Store] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ItemNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Items] ([ItemNo], [Name], [Price], [Quantity in Store]) VALUES (100, N'A', 1000, 100)
INSERT [dbo].[Items] ([ItemNo], [Name], [Price], [Quantity in Store]) VALUES (200, N'B', 2000, 50)
INSERT [dbo].[Items] ([ItemNo], [Name], [Price], [Quantity in Store]) VALUES (300, N'C', 3000, 60)
INSERT [dbo].[Items] ([ItemNo], [Name], [Price], [Quantity in Store]) VALUES (400, N'D', 6000, 400)
/****** Object:  Table [dbo].[Courses]    Script Date: 02/17/2017 13:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerNo] [varchar](2) NOT NULL,
	[Name] [varchar](30) NULL,
	[City] [varchar](3) NULL,
	[Phone] [varchar](11) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Customers] ([CustomerNo], [Name], [City], [Phone]) VALUES (N'C1', N'AHMED ALI', N'LHR', N'111111')
INSERT [dbo].[Customers] ([CustomerNo], [Name], [City], [Phone]) VALUES (N'C2', N'ALI', N'LHR', N'222222')
INSERT [dbo].[Customers] ([CustomerNo], [Name], [City], [Phone]) VALUES (N'C3', N'AYESHA', N'LHR', N'333333')
INSERT [dbo].[Customers] ([CustomerNo], [Name], [City], [Phone]) VALUES (N'C4', N'BILAL', N'KHI', N'444444')
INSERT [dbo].[Customers] ([CustomerNo], [Name], [City], [Phone]) VALUES (N'C5', N'SADAF', N'KHI', N'555555')
INSERT [dbo].[Customers] ([CustomerNo], [Name], [City], [Phone]) VALUES (N'C6', N'FARAH', N'ISL', NULL)
/****** Object:  Table [dbo].[Order]    Script Date: 02/17/2017 13:04:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Order](
	[OrderNo] [int] NOT NULL,
	[CustomerNo] [varchar](2) NULL,
	[Date] [date] NULL,
	[Total_Items_Ordered] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Order] ([OrderNo], [CustomerNo], [Date], [Total_Items_Ordered]) VALUES (1, N'C1', CAST(0x7F360B00 AS Date), 30)
INSERT [dbo].[Order] ([OrderNo], [CustomerNo], [Date], [Total_Items_Ordered]) VALUES (2, N'C3', CAST(0x2A3C0B00 AS Date), 5)
INSERT [dbo].[Order] ([OrderNo], [CustomerNo], [Date], [Total_Items_Ordered]) VALUES (3, N'C3', CAST(0x493C0B00 AS Date), 20)
INSERT [dbo].[Order] ([OrderNo], [CustomerNo], [Date], [Total_Items_Ordered]) VALUES (4, N'C4', CAST(0x4A3C0B00 AS Date), 15)
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 02/17/2017 13:04:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[OrderNo] [int] NOT NULL,
	[ItemNo] [int] NOT NULL,
	[Quantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderNo] ASC,
	[ItemNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[OrderDetails] ([OrderNo], [ItemNo], [Quantity]) VALUES (1, 200, 20)
INSERT [dbo].[OrderDetails] ([OrderNo], [ItemNo], [Quantity]) VALUES (1, 400, 10)
INSERT [dbo].[OrderDetails] ([OrderNo], [ItemNo], [Quantity]) VALUES (2, 200, 5)
INSERT [dbo].[OrderDetails] ([OrderNo], [ItemNo], [Quantity]) VALUES (3, 200, 60)

GO
/****** Object:  ForeignKey [FK__OrderDeta__ItemN__4316F928]    Script Date: 02/03/2017 13:55:38 ******/
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD FOREIGN KEY([ItemNo])
REFERENCES [dbo].[Items] ([ItemNo])
GO
/****** Object:  ForeignKey [FK__OrderDeta__Order__4222D4EF]    Script Date: 02/03/2017 13:55:38 ******/
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD FOREIGN KEY([OrderNo])
REFERENCES [dbo].[Order] ([OrderNo])
GO

--Q1 
CREATE PROCEDURE PlaceOrder
    @OrderNumber INT,
    @ItemNumber INT,
    @QuantityOrdered INT
AS
BEGIN
    DECLARE @QuantityInStore INT;
    SELECT @QuantityInStore = [Quantity in Store]
    FROM Items
    WHERE ItemNo = @ItemNumber;

    IF @QuantityInStore IS NULL OR @QuantityInStore < @QuantityOrdered
    BEGIN
        PRINT 'Only ' + CAST(@QuantityInStore AS VARCHAR) + ' is present, which is less than your req quantity.';
    END
    ELSE
    BEGIN
        INSERT INTO OrderDetails (OrderNo, ItemNo, Quantity)
        VALUES (@OrderNumber, @ItemNumber, @QuantityOrdered);

        UPDATE Items
        SET [Quantity in Store] = [Quantity in Store] - @QuantityOrdered
        WHERE ItemNo = @ItemNumber;

        PRINT 'Order placed successfully.';
    END
END;

EXEC PlaceOrder
@OrderNumber = 5, @ItemNumber = 200, @QuantityOrdered = 10;

--Q2

CREATE PROCEDURE CustomerSignup
    @CustomerNo VARCHAR(2),
    @Name VARCHAR(30),
    @City VARCHAR(3),
    @Phone VARCHAR(11),
    @Flag INT OUTPUT
AS
BEGIN
    -- Rule 1
    IF EXISTS (SELECT 1 FROM Customers WHERE CustomerNo = @CustomerNo)
    BEGIN
        SET @Flag = 1;
        RETURN;
    END

    -- Rule 2
    IF @City IS NULL
    BEGIN
        SET @Flag = 2; 
        RETURN;
    END

    -- Rule 3
    IF LEN(@Phone) <> 6
    BEGIN
        SET @Flag = 3;
        RETURN;
    END
    INSERT INTO Customers (CustomerNo, Name, City, Phone)
    VALUES (@CustomerNo, @Name, @City, @Phone);

    SET @Flag = 0; -- Success
END;

DECLARE @Flag INT;
EXEC CustomerSignup 'A1', 'Taha Saqib', 'Lhr', '123123', @Flag OUTPUT;
SELECT @Flag AS 'Result';

--Q3
CREATE PROCEDURE CancelOrder
    @CustomerNo VARCHAR(2),
    @OrderNo INT
AS
BEGIN
    DECLARE @CustomerName VARCHAR(30);
    SELECT @CustomerName = Name FROM Customers WHERE CustomerNo = @CustomerNo;

    IF EXISTS (SELECT 1 FROM [Order] WHERE OrderNo = @OrderNo AND CustomerNo = @CustomerNo)
    BEGIN
        DELETE FROM [OrderDetails] WHERE OrderNo = @OrderNo;
        DELETE FROM [Order] WHERE OrderNo = @OrderNo;
    END
    ELSE
        PRINT 'Order no ' + CAST(@OrderNo AS VARCHAR) + ' is not of ' + @CustomerNo + ' ' + @CustomerName;
    END
END;

EXEC CancelOrder @CustomerNo = 'C1', @OrderNo = 1;

--Q4

CREATE PROCEDURE CalculateTotalPoints
    @CustomerName VARCHAR(30)
AS
BEGIN
    DECLARE @TotalPoints INT;
    SELECT @TotalPoints = (SUM(od.Quantity * i.Price) / 100)
    FROM [OrderDetails] od
    JOIN Items i ON od.ItemNo = i.ItemNo
    JOIN [Order] o ON od.OrderNo = o.OrderNo
    JOIN Customers c ON o.CustomerNo = c.CustomerNo
    WHERE c.Name = @CustomerName;

    SELECT @TotalPoints AS 'TotalPoints';
END;
EXEC CalculateTotalPoints 'AHMED ALI';

--Q5

CREATE PROCEDURE PointsOrderCosts
    @CustomerName varchar(30)
AS
BEGIN
    DECLARE @TotalPoints int;
    SELECT @TotalPoints = TotalPoints
    FROM Customers
    WHERE Name = @CustomerName;
    SELECT od.OrderNo, SUM(i.Price * od.Quantity) AS TotalCost
    FROM OrderDetails od
    JOIN Items i ON od.ItemNo = i.ItemNo
    GROUP BY od.OrderNo;
    SELECT @TotalPoints AS 'Total Points';
END

EXEC PointsOrderCosts 'CustomerName';
