SELECT PARTSUPP.PS_SUPPLYCOST, SUPPLIER.S_PHONE FROM SUPPLIER JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY ORDER BY PARTSUPP.PS_SUPPLYCOST ASC, SUPPLIER.S_PHONE ASC;
