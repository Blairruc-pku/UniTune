SELECT CUSTOMER.C_NAME, NATION.N_NATIONKEY, AVG(NATION.N_REGIONKEY) FROM CUSTOMER JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY GROUP BY CUSTOMER.C_NAME, NATION.N_NATIONKEY ORDER BY AVG(NATION.N_REGIONKEY) DESC;
