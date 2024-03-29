-- cau a ne	
Select sod.ProductID, SUM(sod.UnitPrice) as TongTien
From dbo.n_SalesOrderDetail as sod join dbo.n_Product as pro	
on(sod.SalesOrderID = pro.ProductID) join dbo.n_SalesOrderHeader as soh
on(sod.SalesOrderID = soh.SalesOrderID)
Where soh.OrderDate < '2014-05-15' 
Group by sod.ProductID 	
Order by sod.ProductID ASC


Select sod.ProductID, SUM(sod.UnitPriceDiscount) as TongTien
From dbo.n_SalesOrderDetail as sod join dbo.n_Product as pro	
on(sod.SalesOrderID = pro.ProductID) join dbo.n_SalesOrderHeader as soh
on(sod.SalesOrderID = soh.SalesOrderID)
Where soh.OrderDate < '2014-05-15' 
Group by sod.ProductID 	
Order by sod.ProductID ASC
--cau b ne
create proc showGood
	@inputYear int
as
begin
		declare @pastYear int, @thisYear int
		set @pastYear = (select soh.SalesPersonID, count(soh.SalesPersonID) as Appear from n_SalesOrderDetail sod join n_SalesOrderHeader soh on sod.SalesOrderID = soh.SalesOrderID 
		where year(soh.ModifiedDate) = @inputYear-1
		group by soh.SalesPersonID
		)

		set @thisYear = (select soh.SalesPersonID, count(soh.SalesPersonID) as Appear from n_SalesOrderDetail sod join n_SalesOrderHeader soh on sod.SalesOrderID = soh.SalesOrderID 
		where year(soh.ModifiedDate) = @inputYear
		group by soh.SalesPersonID
		)
		if(@pastYear < @thisYear)
			print'this is the person'
	end
go

exec showGood 2013
--cau c ne
SELECT SUM(snn.totaldue) AS "Online Order" FROM dbo.n_salesorderheader AS snn WHERE snn.onlineorderflag = 1
SELECT SUM(snn.totaldue) AS "Offline Order" FROM dbo.n_salesorderheader AS snn WHERE snn.onlineorderflag = 0
--cau d ne
SELECT snn.customerid 
FROM n_salesorderheader snn JOIN n_salesorderdetail AS snl ON(snn.salesorderid = snl.salesorderid) 
WHERE snl.productid = 
	(SELECT cdl.productid 
	FROM dbo.n_product AS cdl 
	WHERE cdl.name LIKE 'Water Bottle - 30 oz.') 
GROUP BY snn.customerid

SELECT * FROM n_salesorderdetail ORDER BY modifieddate DESC
SELECT * FROM n_salesorderheader ORDER BY modifieddate DESC 

-- cau e ne
SELECT snn.customerid, snn.modifieddate 
FROM n_salesorderheader snn , n_salesorderdetail snl --ON(snn.salesorderid = snl.salesorderid) 
WHERE (snl.productid = 
	(SELECT cdl.productid 
	FROM dbo.n_product AS cdl 
	WHERE cdl.name LIKE 'Water Bottle - 30 oz.') and (snn.modifieddate > '20130501' and snn.modifieddate > '20130801') )
GROUP BY snn.customerid, snn.ModifiedDate

-- cau h ne 
-- using index
CREATE NONCLUSTERED INDEX inde_test
ON [dbo].[n_Product] ([ProductID])
GO

Select sod.ProductID, SUM(sod.UnitPrice) as TongTien
From dbo.n_SalesOrderDetail as sod join dbo.n_SalesOrderHeader as soh	
on(sod.SalesOrderID = soh.SalesOrderID)
Where soh.OrderDate < '2014-05-15' and sod.ProductID = 
	(Select pro.ProductID
	From dbo.n_Product as pro
	where sod.ProductID = pro.ProductID)
Group by sod.ProductID 	
Order by sod.ProductID ASC

Select sod.ProductID, SUM(sod.UnitPriceDiscount) as TongTien
From dbo.n_SalesOrderDetail as sod join dbo.n_SalesOrderHeader as soh	
on(sod.SalesOrderID = soh.SalesOrderID)
Where soh.OrderDate < '2014-05-15' and sod.ProductID = 
	(Select pro.ProductID
	From dbo.n_Product as pro
	where sod.ProductID = pro.ProductID)
Group by sod.ProductID 	
Order by sod.ProductID ASC

SELECT ModifiedDate FROM dbo.n_SalesOrderHeader ORDER BY ModifiedDate ASC
--cau i demo
--partition p2 include date 2013-05-01 < date < 2013-09-01
CREATE PARTITION FUNCTION partitionIndex(DATETIME) AS RANGE LEFT FOR VALUES ('20130501', '20130901')
GO 
SELECT snn.customerid, snn.modifieddate 
FROM n_salesorderheader snn JOIN n_salesorderdetail snl ON(snn.salesorderid = snl.salesorderid) 
WHERE (snl.productid = 
	(SELECT cdl.productid 
	FROM dbo.n_product AS cdl WITH(PARTITION('p2'))
	WHERE cdl.name LIKE 'Water Bottle - 30 oz.') )
GROUP BY snn.customerid, snn.ModifiedDate