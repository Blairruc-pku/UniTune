SELECT ORDERS.O_ORDERPRIORITY, LINEITEM.L_RECEIPTDATE FROM LINEITEM JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY;
