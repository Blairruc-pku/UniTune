SELECT REGION.R_REGIONKEY, MAX(REGION.R_NAME) FROM REGION GROUP BY REGION.R_REGIONKEY HAVING MAX(REGION.R_NAME) > 'NATION' ORDER BY MAX(REGION.R_NAME) DESC;
