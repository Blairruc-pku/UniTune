SELECT PART.P_PARTKEY, COUNT(PART.P_COMMENT) FROM PART GROUP BY PART.P_PARTKEY;