SELECT PART.P_MFGR, PARTSUPP.PS_SUPPKEY, SUM(PART.P_SIZE) FROM PARTSUPP JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY WHERE PARTSUPP.PS_AVAILQTY < 2104 GROUP BY PART.P_MFGR, PARTSUPP.PS_SUPPKEY ORDER BY SUM(PART.P_SIZE) ASC;
