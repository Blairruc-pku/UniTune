SELECT PART.P_BRAND, MIN(PART.P_COMMENT) FROM PART GROUP BY PART.P_BRAND;
