SELECT ORDERS.O_TOTALPRICE, LINEITEM.L_RETURNFLAG FROM LINEITEM, ORDERS WHERE ORDERS.O_SHIPPRIORITY <= 0;
