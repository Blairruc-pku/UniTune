SELECT ORDERS.O_ORDERPRIORITY, CUSTOMER.C_CUSTKEY, NATION.N_REGIONKEY, AVG(ORDERS.O_TOTALPRICE) FROM ORDERS, CUSTOMER, NATION WHERE ORDERS.O_TOTALPRICE != 331607.10 GROUP BY ORDERS.O_ORDERPRIORITY, CUSTOMER.C_CUSTKEY, NATION.N_REGIONKEY ORDER BY ORDERS.O_ORDERPRIORITY ASC, CUSTOMER.C_CUSTKEY DESC, NATION.N_REGIONKEY DESC;
