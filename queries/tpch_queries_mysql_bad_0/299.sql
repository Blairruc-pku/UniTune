SELECT PART.P_CONTAINER, COUNT(PART.P_CONTAINER) FROM PART GROUP BY PART.P_CONTAINER HAVING COUNT(PART.P_CONTAINER) < 5;
