SELECT SUPPLIER.S_ACCTBAL, NATION.N_REGIONKEY FROM NATION JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY WHERE SUPPLIER.S_PHONE < '27-498-742-3860' ORDER BY NATION.N_REGIONKEY ASC;