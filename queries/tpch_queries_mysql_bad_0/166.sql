SELECT SUPPLIER.S_ACCTBAL, PARTSUPP.PS_COMMENT FROM SUPPLIER JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY WHERE PARTSUPP.PS_SUPPKEY != 752;