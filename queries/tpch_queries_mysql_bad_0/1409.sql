SELECT PART.P_COMMENT, MAX(PART.P_TYPE) FROM PART GROUP BY PART.P_COMMENT ORDER BY PART.P_COMMENT ASC;
