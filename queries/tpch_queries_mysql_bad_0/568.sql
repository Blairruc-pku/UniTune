SELECT SUPPLIER.S_PHONE, NATION.N_REGIONKEY FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY WHERE SUPPLIER.S_NAME <= 'SUPPLIER#000000006       ' ORDER BY SUPPLIER.S_PHONE ASC;