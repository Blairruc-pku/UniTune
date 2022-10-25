SELECT PART.P_COMMENT, COUNT(PART.P_NAME), MIN(PART.P_PARTKEY) FROM PART GROUP BY PART.P_COMMENT HAVING MIN(PART.P_PARTKEY) <= 46 ORDER BY PART.P_COMMENT DESC;