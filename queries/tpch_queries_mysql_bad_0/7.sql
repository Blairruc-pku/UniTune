SELECT PART.P_COMMENT, COUNT(PART.P_COMMENT) FROM PART GROUP BY PART.P_COMMENT HAVING COUNT(PART.P_COMMENT) != 1;
