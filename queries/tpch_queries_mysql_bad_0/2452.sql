SELECT SUPPLIER.S_COMMENT, NATION.N_REGIONKEY FROM NATION JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY WHERE SUPPLIER.S_COMMENT >= 'FINAL ACCOUNTS. REGULAR DOLPHINS USE AGAINST THE FURIOUSLY IRONIC DECOYS. ' ORDER BY NATION.N_REGIONKEY ASC, SUPPLIER.S_COMMENT DESC;
