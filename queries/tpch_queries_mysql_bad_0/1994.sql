SELECT LINEITEM.L_QUANTITY, PARTSUPP.PS_SUPPKEY FROM PARTSUPP, LINEITEM WHERE LINEITEM.L_SUPPKEY != 542 ORDER BY PARTSUPP.PS_SUPPKEY ASC;