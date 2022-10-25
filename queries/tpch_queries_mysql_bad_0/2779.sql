SELECT PART.P_CONTAINER, SUPPLIER.S_ADDRESS, PARTSUPP.PS_SUPPKEY, COUNT(PARTSUPP.PS_COMMENT), SUM(PARTSUPP.PS_SUPPKEY) FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY WHERE PART.P_PARTKEY > 155 GROUP BY PART.P_CONTAINER, SUPPLIER.S_ADDRESS, PARTSUPP.PS_SUPPKEY HAVING SUM(PARTSUPP.PS_SUPPKEY) <= 347;