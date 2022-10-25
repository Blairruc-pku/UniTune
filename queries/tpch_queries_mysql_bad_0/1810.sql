SELECT PART.P_RETAILPRICE, CUSTOMER.C_ADDRESS, ORDERS.O_ORDERDATE, NATION.N_COMMENT, SUPPLIER.S_COMMENT, PARTSUPP.PS_SUPPKEY, MAX(NATION.N_REGIONKEY) FROM ORDERS, CUSTOMER, NATION, SUPPLIER, PARTSUPP, PART WHERE NATION.N_REGIONKEY < REQUESTS WAS QUICKLY AGAINST TH GROUP BY PART.P_RETAILPRICE, CUSTOMER.C_ADDRESS, ORDERS.O_ORDERDATE, NATION.N_COMMENT, SUPPLIER.S_COMMENT, PARTSUPP.PS_SUPPKEY;
