SELECT ORDERS.O_ORDERPRIORITY, CUSTOMER.C_ADDRESS, LINEITEM.L_EXTENDEDPRICE, PARTSUPP.PS_PARTKEY FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY;