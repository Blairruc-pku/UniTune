SELECT PARTSUPP.PS_AVAILQTY, LINEITEM.L_RECEIPTDATE FROM PARTSUPP JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY ORDER BY PARTSUPP.PS_AVAILQTY DESC, LINEITEM.L_RECEIPTDATE DESC;