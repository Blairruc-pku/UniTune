SELECT REGION.R_NAME, SUM(REGION.R_REGIONKEY) FROM REGION GROUP BY REGION.R_NAME;
