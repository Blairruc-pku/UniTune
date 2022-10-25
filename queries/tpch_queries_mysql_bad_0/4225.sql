SELECT PARTSUPP.PS_AVAILQTY, PART.P_COMMENT, COUNT(PART.P_CONTAINER) FROM PART, PARTSUPP GROUP BY PARTSUPP.PS_AVAILQTY, PART.P_COMMENT HAVING COUNT(PART.P_CONTAINER) < 1 ORDER BY COUNT(PART.P_CONTAINER) DESC;
