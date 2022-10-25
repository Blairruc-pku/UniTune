SELECT ORDERS.O_CUSTKEY, SUPPLIER.S_NAME, CUSTOMER.C_ADDRESS, PARTSUPP.PS_COMMENT, LINEITEM.L_SUPPKEY, NATION.N_NATIONKEY, REGION.R_NAME FROM CUSTOMER, ORDERS, LINEITEM, PARTSUPP, SUPPLIER, NATION, REGION ORDER BY NATION.N_NATIONKEY DESC, PARTSUPP.PS_COMMENT ASC;
