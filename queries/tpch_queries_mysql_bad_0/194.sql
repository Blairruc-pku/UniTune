SELECT PARTSUPP.PS_SUPPKEY, SUPPLIER.S_ADDRESS FROM SUPPLIER, PARTSUPP ORDER BY SUPPLIER.S_ADDRESS ASC, PARTSUPP.PS_SUPPKEY ASC;