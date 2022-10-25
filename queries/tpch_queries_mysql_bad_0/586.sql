SELECT PART.P_CONTAINER, PARTSUPP.PS_COMMENT, AVG(PART.P_PARTKEY) FROM PARTSUPP JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY GROUP BY PART.P_CONTAINER, PARTSUPP.PS_COMMENT HAVING AVG(PART.P_PARTKEY) != 185 ORDER BY AVG(PART.P_PARTKEY) ASC;