SELECT SUPPLIER.S_NATIONKEY, LINEITEM.L_RECEIPTDATE, PARTSUPP.PS_COMMENT FROM SUPPLIER JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY;
