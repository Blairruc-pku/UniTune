SELECT CUSTOMER.C_NATIONKEY, NATION.N_NAME FROM NATION, CUSTOMER WHERE CUSTOMER.C_COMMENT < 'REQUESTS. SPECIAL, EXPRESS REQUESTS NAG SLYLY FURIOUSL' ORDER BY NATION.N_NAME ASC;
