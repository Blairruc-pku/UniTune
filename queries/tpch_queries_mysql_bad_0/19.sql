SELECT NATION.N_COMMENT, CUSTOMER.C_PHONE, MAX(NATION.N_REGIONKEY) FROM CUSTOMER, NATION WHERE CUSTOMER.C_NATIONKEY = 17 GROUP BY NATION.N_COMMENT, CUSTOMER.C_PHONE ORDER BY CUSTOMER.C_PHONE DESC;
