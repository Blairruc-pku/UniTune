SELECT PART.P_SIZE, SUM(PART.P_SIZE) FROM PART WHERE PART.P_RETAILPRICE >= 903.00 AND PART.P_PARTKEY > 116 GROUP BY PART.P_SIZE HAVING SUM(PART.P_SIZE) >= 39;
