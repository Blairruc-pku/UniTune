SELECT PARTSUPP.PS_PARTKEY, SUPPLIER.S_ACCTBAL, MAX(SUPPLIER.S_PHONE) FROM PARTSUPP, SUPPLIER GROUP BY PARTSUPP.PS_PARTKEY, SUPPLIER.S_ACCTBAL HAVING MAX(SUPPLIER.S_PHONE) != '25-843-787-7479';
