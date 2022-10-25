SELECT ORDERS.O_TOTALPRICE, NATION.N_REGIONKEY, LINEITEM.L_SHIPINSTRUCT, CUSTOMER.C_NAME, SUPPLIER.S_PHONE, PARTSUPP.PS_AVAILQTY, MAX(ORDERS.O_TOTALPRICE) FROM NATION, SUPPLIER, PARTSUPP, LINEITEM, ORDERS, CUSTOMER GROUP BY ORDERS.O_TOTALPRICE, NATION.N_REGIONKEY, LINEITEM.L_SHIPINSTRUCT, CUSTOMER.C_NAME, SUPPLIER.S_PHONE, PARTSUPP.PS_AVAILQTY;
