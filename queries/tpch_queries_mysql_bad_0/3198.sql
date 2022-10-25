SELECT SUPPLIER.S_ADDRESS, LINEITEM.L_SHIPMODE, CUSTOMER.C_COMMENT, ORDERS.O_ORDERPRIORITY, NATION.N_NAME FROM LINEITEM, ORDERS, CUSTOMER, NATION, SUPPLIER ORDER BY NATION.N_NAME ASC, SUPPLIER.S_ADDRESS ASC;
