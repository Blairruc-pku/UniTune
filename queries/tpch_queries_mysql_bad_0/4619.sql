SELECT PARTSUPP.PS_SUPPKEY, SUPPLIER.S_NATIONKEY FROM SUPPLIER, PARTSUPP WHERE SUPPLIER.S_ACCTBAL = 4192.40 AND PARTSUPP.PS_SUPPKEY != 21 ORDER BY PARTSUPP.PS_SUPPKEY ASC, SUPPLIER.S_NATIONKEY ASC;
