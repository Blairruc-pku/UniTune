SELECT ORDERS.O_ORDERDATE, LINEITEM.L_SHIPMODE, CUSTOMER.C_COMMENT FROM CUSTOMER, ORDERS, LINEITEM WHERE LINEITEM.L_SHIPMODE = 'SHIP      ' AND LINEITEM.L_SHIPINSTRUCT <= 'NONE                     ';
