SELECT REGION.R_REGIONKEY, MAX(REGION.R_NAME), MAX(REGION.R_REGIONKEY) FROM REGION GROUP BY REGION.R_REGIONKEY;
