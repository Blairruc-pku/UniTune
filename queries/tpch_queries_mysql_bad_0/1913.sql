SELECT CUSTOMER.C_NAME, ORDERS.O_ORDERSTATUS, LINEITEM.L_COMMITDATE FROM LINEITEM JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY WHERE LINEITEM.L_ORDERKEY >= 2849 ORDER BY CUSTOMER.C_NAME DESC, ORDERS.O_ORDERSTATUS DESC;