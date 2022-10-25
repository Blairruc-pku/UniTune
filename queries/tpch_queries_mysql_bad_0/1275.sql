SELECT SUPPLIER.S_ACCTBAL, MAX(SUPPLIER.S_SUPPKEY), COUNT(SUPPLIER.S_ACCTBAL) FROM SUPPLIER GROUP BY SUPPLIER.S_ACCTBAL HAVING COUNT(SUPPLIER.S_ACCTBAL) < 5 ORDER BY SUPPLIER.S_ACCTBAL DESC;
