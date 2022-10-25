SELECT PARTSUPP.PS_SUPPLYCOST, PART.P_MFGR, MIN(PARTSUPP.PS_SUPPLYCOST), COUNT(PART.P_NAME) FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY GROUP BY PARTSUPP.PS_SUPPLYCOST, PART.P_MFGR HAVING MIN(PARTSUPP.PS_SUPPLYCOST) = 107.17 ORDER BY COUNT(PART.P_NAME) DESC, MIN(PARTSUPP.PS_SUPPLYCOST) ASC;
