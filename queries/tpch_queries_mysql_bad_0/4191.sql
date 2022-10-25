SELECT PART.P_BRAND, LINEITEM.L_COMMITDATE, NATION.N_NATIONKEY, ORDERS.O_CLERK, SUPPLIER.S_NAME, CUSTOMER.C_NAME, PARTSUPP.PS_PARTKEY FROM PART, PARTSUPP, LINEITEM, ORDERS, CUSTOMER, NATION, SUPPLIER ORDER BY ORDERS.O_CLERK DESC;
