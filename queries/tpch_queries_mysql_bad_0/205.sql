SELECT CUSTOMER.C_PHONE, NATION.N_NATIONKEY, SUM(CUSTOMER.C_CUSTKEY) FROM NATION JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY GROUP BY CUSTOMER.C_PHONE, NATION.N_NATIONKEY HAVING SUM(CUSTOMER.C_CUSTKEY) >= 142 ORDER BY SUM(CUSTOMER.C_CUSTKEY) ASC;
