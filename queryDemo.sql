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
--cau i demo
--partition p2 include date 2013-05-01 < date < 2013-09-01
CREATE PARTITION FUNCTION partitionIndex(DATETIME) AS RANGE LEFT FOR VALUES ('20130501', '20130901')
GO 
SELECT snn.customerid, snn.modifieddate 
FROM n_salesorderheader snn JOIN n_salesorderdetail snl ON(snn.salesorderid = snl.salesorderid) 
WHERE (snl.productid = 
	(SELECT cdl.productid 
	FROM dbo.n_product AS cdl WITH PARTITION('p2')
	WHERE cdl.name LIKE 'Water Bottle - 30 oz.') )
GROUP BY snn.customerid, snn.ModifiedDate