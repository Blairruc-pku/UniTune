SELECT PART.P_TYPE, SUM(PART.P_RETAILPRICE) FROM PART WHERE PART.P_TYPE != 'SMALL PLATED BRASS' GROUP BY PART.P_TYPE HAVING SUM(PART.P_RETAILPRICE) >= 1034.13;
