SELECT PART.P_RETAILPRICE, COUNT(PART.P_BRAND) FROM PART GROUP BY PART.P_RETAILPRICE HAVING COUNT(PART.P_BRAND) >= 0 ORDER BY COUNT(PART.P_BRAND) DESC;
