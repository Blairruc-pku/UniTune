SELECT REGION.R_REGIONKEY, COUNT(REGION.R_COMMENT), AVG(REGION.R_REGIONKEY), MIN(REGION.R_REGIONKEY) FROM REGION WHERE REGION.R_REGIONKEY != SLEEP QUICKLY. REQ GROUP BY REGION.R_REGIONKEY HAVING AVG(REGION.R_REGIONKEY) <= CUSTOMER ORDER BY MIN(REGION.R_REGIONKEY) ASC, AVG(REGION.R_REGIONKEY) DESC;
