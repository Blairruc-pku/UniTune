SELECT NATION.N_NAME, ORDERS.O_ORDERPRIORITY, CUSTOMER.C_COMMENT, MAX(CUSTOMER.C_ADDRESS) FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY GROUP BY NATION.N_NAME, ORDERS.O_ORDERPRIORITY, CUSTOMER.C_COMMENT HAVING MAX(CUSTOMER.C_ADDRESS) > 'XXVSJSLAGTN' ORDER BY MAX(CUSTOMER.C_ADDRESS) ASC;
