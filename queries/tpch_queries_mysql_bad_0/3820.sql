SELECT PART.P_SIZE, MIN(PART.P_TYPE) FROM PART GROUP BY PART.P_SIZE;