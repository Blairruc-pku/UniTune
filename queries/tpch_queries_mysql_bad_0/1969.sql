SELECT LINEITEM.L_RETURNFLAG, ORDERS.O_CUSTKEY FROM LINEITEM, ORDERS ORDER BY ORDERS.O_CUSTKEY DESC, LINEITEM.L_RETURNFLAG DESC;