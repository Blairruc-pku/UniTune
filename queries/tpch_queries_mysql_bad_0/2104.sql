SELECT PART.P_SIZE, AVG(PART.P_PARTKEY) FROM PART WHERE PART.P_BRAND <= 'BRAND#45  ' GROUP BY PART.P_SIZE;
