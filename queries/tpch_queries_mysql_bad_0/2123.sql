SELECT PARTSUPP.PS_SUPPKEY, SUPPLIER.S_NATIONKEY FROM PARTSUPP JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY WHERE PARTSUPP.PS_PARTKEY < 100;
