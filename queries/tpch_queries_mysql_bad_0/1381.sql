SELECT SUPPLIER.S_NATIONKEY, COUNT(SUPPLIER.S_NAME) FROM SUPPLIER WHERE SUPPLIER.S_ACCTBAL > 4192.40 GROUP BY SUPPLIER.S_NATIONKEY HAVING COUNT(SUPPLIER.S_NAME) <= 1 ORDER BY SUPPLIER.S_NATIONKEY ASC;
