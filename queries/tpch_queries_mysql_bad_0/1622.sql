SELECT ORDERS.O_SHIPPRIORITY, LINEITEM.L_RECEIPTDATE FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY;
