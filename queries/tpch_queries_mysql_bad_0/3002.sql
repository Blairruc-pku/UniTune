SELECT NATION.N_COMMENT, SUPPLIER.S_PHONE FROM NATION JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY WHERE SUPPLIER.S_ADDRESS < 'BK7AH4CK8SYQTEPEMVMKKGMWG' ORDER BY SUPPLIER.S_PHONE DESC, NATION.N_COMMENT ASC;