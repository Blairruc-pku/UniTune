SELECT PART.P_PARTKEY, SUPPLIER.S_SUPPKEY, PARTSUPP.PS_SUPPLYCOST FROM SUPPLIER JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY;
