SELECT CUSTOMER.C_NAME, NATION.N_NAME, REGION.R_COMMENT FROM REGION JOIN NATION ON NATION.N_REGIONKEY=REGION.R_REGIONKEY JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY WHERE CUSTOMER.C_ADDRESS > 'RKPX2OFZY0VN 8WGWZ7F2EAVMMORL1K8IH';