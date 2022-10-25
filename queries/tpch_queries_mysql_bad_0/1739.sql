SELECT CUSTOMER.C_PHONE, LINEITEM.L_DISCOUNT, NATION.N_NATIONKEY, PARTSUPP.PS_SUPPLYCOST, SUPPLIER.S_ADDRESS, ORDERS.O_CLERK FROM NATION, CUSTOMER, ORDERS, LINEITEM, PARTSUPP, SUPPLIER ORDER BY CUSTOMER.C_PHONE DESC, PARTSUPP.PS_SUPPLYCOST DESC, LINEITEM.L_DISCOUNT DESC, NATION.N_NATIONKEY DESC, SUPPLIER.S_ADDRESS ASC;