SELECT NATION.N_REGIONKEY, LINEITEM.L_PARTKEY, ORDERS.O_TOTALPRICE, CUSTOMER.C_COMMENT FROM LINEITEM, ORDERS, CUSTOMER, NATION ORDER BY LINEITEM.L_PARTKEY ASC, CUSTOMER.C_COMMENT DESC;