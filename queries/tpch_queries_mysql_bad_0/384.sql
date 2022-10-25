SELECT LINEITEM.L_SHIPMODE, CUSTOMER.C_MKTSEGMENT, ORDERS.O_CUSTKEY, PARTSUPP.PS_AVAILQTY, SUM(LINEITEM.L_DISCOUNT) FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY WHERE CUSTOMER.C_COMMENT > 'ITHELY EVEN ACCOUNTS DETECT SLYLY ABOVE THE FLUFFILY IR' GROUP BY LINEITEM.L_SHIPMODE, CUSTOMER.C_MKTSEGMENT, ORDERS.O_CUSTKEY, PARTSUPP.PS_AVAILQTY;