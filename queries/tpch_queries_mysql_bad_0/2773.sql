SELECT ORDERS.O_ORDERPRIORITY, CUSTOMER.C_MKTSEGMENT FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY WHERE ORDERS.O_ORDERSTATUS < 'F' AND ORDERS.O_ORDERSTATUS = 'O' ORDER BY CUSTOMER.C_MKTSEGMENT ASC;
