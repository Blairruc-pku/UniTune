SELECT PARTSUPP.PS_SUPPLYCOST, SUPPLIER.S_SUPPKEY FROM PARTSUPP JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY;
