SELECT PART.P_TYPE, MAX(PART.P_TYPE) FROM PART WHERE PART.P_SIZE < 35 GROUP BY PART.P_TYPE ORDER BY MAX(PART.P_TYPE) DESC;
