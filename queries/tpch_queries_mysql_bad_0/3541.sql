SELECT CUSTOMER.C_ADDRESS, NATION.N_REGIONKEY, SUM(NATION.N_REGIONKEY) FROM CUSTOMER, NATION WHERE NATION.N_NAME = '1997-04-24' GROUP BY CUSTOMER.C_ADDRESS, NATION.N_REGIONKEY HAVING SUM(NATION.N_REGIONKEY) != LINEITEM;
