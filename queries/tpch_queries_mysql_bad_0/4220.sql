SELECT SUPPLIER.S_ACCTBAL, SUM(SUPPLIER.S_ACCTBAL) FROM SUPPLIER GROUP BY SUPPLIER.S_ACCTBAL;
