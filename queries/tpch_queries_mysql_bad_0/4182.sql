SELECT CUSTOMER.C_ADDRESS, LINEITEM.L_LINESTATUS, ORDERS.O_CUSTKEY, REGION.R_REGIONKEY, NATION.N_NAME, MIN(ORDERS.O_CLERK), MAX(NATION.N_NATIONKEY), MIN(NATION.N_COMMENT) FROM LINEITEM, ORDERS, CUSTOMER, NATION, REGION GROUP BY CUSTOMER.C_ADDRESS, LINEITEM.L_LINESTATUS, ORDERS.O_CUSTKEY, REGION.R_REGIONKEY, NATION.N_NAME HAVING MIN(ORDERS.O_CLERK) = 'CLERK#000000327';
