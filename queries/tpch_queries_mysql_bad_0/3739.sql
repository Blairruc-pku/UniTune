SELECT PARTSUPP.PS_AVAILQTY, SUPPLIER.S_PHONE FROM SUPPLIER JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY ORDER BY PARTSUPP.PS_AVAILQTY ASC;
