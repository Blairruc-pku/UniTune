SELECT SUPPLIER.S_NAME, PART.P_MFGR, PARTSUPP.PS_SUPPLYCOST FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY;
