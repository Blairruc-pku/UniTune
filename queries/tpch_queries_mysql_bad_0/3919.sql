SELECT SUPPLIER.S_PHONE, PARTSUPP.PS_SUPPLYCOST, PART.P_CONTAINER FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY;