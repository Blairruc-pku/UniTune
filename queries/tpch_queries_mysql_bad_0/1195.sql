SELECT CUSTOMER.C_COMMENT, ORDERS.O_ORDERSTATUS FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY WHERE ORDERS.O_ORDERPRIORITY < '2-HIGH         ' AND ORDERS.O_COMMENT > 'NDLE NEVER. BLITHELY REGULAR PACKAGES NAG CAREFULLY ENTICING PLATELETS. CA' ORDER BY CUSTOMER.C_COMMENT DESC;
