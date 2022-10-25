SELECT SUPPLIER.S_ADDRESS, PARTSUPP.PS_PARTKEY, MAX(PARTSUPP.PS_SUPPLYCOST) FROM PARTSUPP JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY GROUP BY SUPPLIER.S_ADDRESS, PARTSUPP.PS_PARTKEY ORDER BY PARTSUPP.PS_PARTKEY DESC, SUPPLIER.S_ADDRESS ASC;
