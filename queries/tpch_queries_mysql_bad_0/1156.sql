SELECT PARTSUPP.PS_COMMENT, LINEITEM.L_RECEIPTDATE FROM LINEITEM JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY ORDER BY LINEITEM.L_RECEIPTDATE ASC, PARTSUPP.PS_COMMENT DESC;