SELECT LINEITEM.L_RETURNFLAG, ORDERS.O_TOTALPRICE FROM LINEITEM JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY WHERE LINEITEM.L_SHIPMODE > 'MAIL      ';
