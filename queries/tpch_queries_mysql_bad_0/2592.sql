SELECT PART.P_TYPE, COUNT(PART.P_CONTAINER) FROM PART WHERE PART.P_BRAND > 'BRAND#41  ' GROUP BY PART.P_TYPE HAVING COUNT(PART.P_CONTAINER) > 6 ORDER BY PART.P_TYPE DESC;
