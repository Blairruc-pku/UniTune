SELECT LINEITEM.L_LINESTATUS, ORDERS.O_COMMENT FROM LINEITEM, ORDERS WHERE ORDERS.O_ORDERSTATUS >= 'P' AND ORDERS.O_SHIPPRIORITY <= 0;
