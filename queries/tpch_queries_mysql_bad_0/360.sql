SELECT ORDERS.O_TOTALPRICE, CUSTOMER.C_NAME, LINEITEM.L_SHIPINSTRUCT, NATION.N_NATIONKEY FROM NATION, CUSTOMER, ORDERS, LINEITEM;