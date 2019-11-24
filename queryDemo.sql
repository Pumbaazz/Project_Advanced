
-- cau a ne
Select sod.ProductID, SUM(sod.UnitPrice) as TongTien
From dbo.n_SalesOrderDetail as sod join dbo.n_Product as pro
on(sod.ProductID = pro.ProductID) join dbo.n_SalesOrderHeader as soh
on(sod.SalesOrderID = soh.SalesOrderID)
where soh.DueDate < '2014-05-15'
Group by sod.ProductID 
Order by sod.ProductID ASC


Select sod.ProductID, SUM(sod.UnitPriceDiscount) as TongTien
From dbo.n_SalesOrderDetail as sod join dbo.n_Product as pro
on(sod.ProductID = pro.ProductID) join dbo.n_SalesOrderHeader as soh
on(sod.SalesOrderID = soh.SalesOrderID)
where soh.DueDate < '2014-05-15'
Group by sod.ProductID 
Order by sod.ProductID ASC

-- cau b ne


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
FROM n_salesorderheader snn JOIN n_salesorderdetail snl ON(snn.salesorderid = snl.salesorderid) 
WHERE (snl.productid = 
	(SELECT cdl.productid 
	FROM dbo.n_product AS cdl 
	WHERE cdl.name LIKE 'Water Bottle - 30 oz.') and (snn.modifieddate > '20130501' and snn.modifieddate > '20130801') )
GROUP BY snn.customerid, snn.ModifiedDate

SELECT ModifiedDate FROM dbo.n_SalesOrderHeader ORDER BY ModifiedDate ASC

CREATE PARTITION FUNCTION partitionIndex(DATETIME) AS RANGE RIGHT FOR VALUES ('20110101', '20120202', '20130101', '20140101', '20150101')