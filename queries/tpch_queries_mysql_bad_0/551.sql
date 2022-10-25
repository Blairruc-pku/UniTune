SELECT LINEITEM.L_COMMENT, ORDERS.O_ORDERSTATUS FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY WHERE LINEITEM.L_TAX < 0.04 AND ORDERS.O_ORDERSTATUS != 'F' ORDER BY LINEITEM.L_COMMENT DESC;