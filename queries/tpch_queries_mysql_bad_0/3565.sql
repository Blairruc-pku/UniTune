SELECT CUSTOMER.C_PHONE, NATION.N_NAME, COUNT(CUSTOMER.C_COMMENT) FROM NATION JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY GROUP BY CUSTOMER.C_PHONE, NATION.N_NAME HAVING COUNT(CUSTOMER.C_COMMENT) = 4 ORDER BY COUNT(CUSTOMER.C_COMMENT) DESC;
