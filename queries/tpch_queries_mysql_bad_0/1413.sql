SELECT ORDERS.O_ORDERPRIORITY, LINEITEM.L_EXTENDEDPRICE FROM ORDERS, LINEITEM WHERE ORDERS.O_ORDERKEY != 4160 ORDER BY LINEITEM.L_EXTENDEDPRICE ASC, ORDERS.O_ORDERPRIORITY DESC;