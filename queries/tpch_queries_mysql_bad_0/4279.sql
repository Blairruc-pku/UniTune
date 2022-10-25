SELECT PARTSUPP.PS_SUPPKEY, SUPPLIER.S_PHONE, LINEITEM.L_SUPPKEY, AVG(LINEITEM.L_DISCOUNT) FROM LINEITEM JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY WHERE LINEITEM.L_PARTKEY > 17289 AND SUPPLIER.S_NATIONKEY = 24 GROUP BY PARTSUPP.PS_SUPPKEY, SUPPLIER.S_PHONE, LINEITEM.L_SUPPKEY ORDER BY PARTSUPP.PS_SUPPKEY ASC;