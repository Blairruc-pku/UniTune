SELECT CUSTOMER.C_MKTSEGMENT, SUPPLIER.S_NATIONKEY, ORDERS.O_TOTALPRICE, LINEITEM.L_RECEIPTDATE, NATION.N_COMMENT FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY WHERE CUSTOMER.C_ADDRESS = '3TVCZJUPZPJ0,DDJ8KW5U';
