SELECT PART.P_BRAND, MIN(PART.P_NAME) FROM PART GROUP BY PART.P_BRAND ORDER BY PART.P_BRAND DESC;
