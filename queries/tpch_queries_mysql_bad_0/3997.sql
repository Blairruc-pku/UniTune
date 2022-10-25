SELECT REGION.R_REGIONKEY, COUNT(REGION.R_NAME) FROM REGION GROUP BY REGION.R_REGIONKEY HAVING COUNT(REGION.R_NAME) >= 1 ORDER BY REGION.R_REGIONKEY DESC;
