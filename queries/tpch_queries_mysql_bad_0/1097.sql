SELECT SUPPLIER.S_SUPPKEY, CUSTOMER.C_NAME, NATION.N_REGIONKEY, COUNT(SUPPLIER.S_COMMENT), MIN(CUSTOMER.C_ACCTBAL), SUM(NATION.N_NATIONKEY) FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY WHERE CUSTOMER.C_ADDRESS < 'KXKLETMLL2JQEA ' AND SUPPLIER.S_PHONE = '24-696-997-4969' GROUP BY SUPPLIER.S_SUPPKEY, CUSTOMER.C_NAME, NATION.N_REGIONKEY;
