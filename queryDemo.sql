--cau c ne
SELECT SUM(snn.totaldue) AS "Online Order" FROM dbo.n_salesorderheader AS snn WHERE snn.onlineorderflag = 1
SELECT SUM(snn.totaldue) AS "Offline Order" FROM dbo.n_salesorderheader AS snn WHERE snn.onlineorderflag = 0
--cau d ne
SELECT snn.customerid FROM n_salesorderheader snn JOIN n_salesorderdetail AS snl ON(snn.salesorderid = snl.salesorderid) WHERE snl.productid = (SELECT cdl.productid from dbo.n_product AS cdl WHERE cdl.name LIKE 'Water Bottle - 30 oz.') GROUP BY snn.customerid

SELECT * FROM n_salesorderdetail ORDER BY modifieddate DESC
SELECT * FROM n_salesorderheader ORDER BY modifieddate DESC 
