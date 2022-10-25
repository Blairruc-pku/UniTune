SELECT ORDERS.O_COMMENT, CUSTOMER.C_PHONE, PARTSUPP.PS_SUPPKEY, LINEITEM.L_RETURNFLAG FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY WHERE CUSTOMER.C_PHONE > '27-269-357-4674' AND ORDERS.O_COMMENT <= 'KLY. FLUFFILY IRONIC REQUESTS USE QUI';