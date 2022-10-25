SELECT PARTSUPP.PS_COMMENT, CUSTOMER.C_CUSTKEY, SUPPLIER.S_ADDRESS, ORDERS.O_ORDERDATE, NATION.N_NATIONKEY, MIN(ORDERS.O_TOTALPRICE) FROM PARTSUPP JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY WHERE SUPPLIER.S_ACCTBAL > 7627.85 AND CUSTOMER.C_ADDRESS > 'JD2XZZI UMID,DCTNBLXKJ9Q0TLP2IQ6ZCO3J' AND SUPPLIER.S_NAME != 'SUPPLIER#000000001       ' GROUP BY PARTSUPP.PS_COMMENT, CUSTOMER.C_CUSTKEY, SUPPLIER.S_ADDRESS, ORDERS.O_ORDERDATE, NATION.N_NATIONKEY ORDER BY MIN(ORDERS.O_TOTALPRICE) DESC;
