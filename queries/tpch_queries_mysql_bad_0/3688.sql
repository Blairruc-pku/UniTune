SELECT CUSTOMER.C_CUSTKEY, ORDERS.O_ORDERKEY, LINEITEM.L_LINENUMBER, NATION.N_COMMENT FROM NATION, CUSTOMER, ORDERS, LINEITEM WHERE ORDERS.O_COMMENT < 'ING ACCOUNTS EAT. CAREFULLY REGULAR PACKA' AND LINEITEM.L_DISCOUNT >= 0.04 AND ORDERS.O_COMMENT = 'Y SILENT ACCOUNTS SL';
