SELECT SUPPLIER.S_NATIONKEY, NATION.N_REGIONKEY FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY;