SELECT SUPPLIER.S_PHONE, PARTSUPP.PS_SUPPKEY FROM PARTSUPP JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY ORDER BY PARTSUPP.PS_SUPPKEY DESC;
