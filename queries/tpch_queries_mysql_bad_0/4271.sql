SELECT PART.P_NAME, PARTSUPP.PS_SUPPLYCOST, COUNT(PART.P_BRAND) FROM PARTSUPP, PART GROUP BY PART.P_NAME, PARTSUPP.PS_SUPPLYCOST;
