SELECT REGION.R_REGIONKEY, NATION.N_NATIONKEY FROM NATION, REGION WHERE NATION.N_COMMENT > '49905.24' AND REGION.R_COMMENT = 'Y ACCORDING TO THE FLUFFILY ' ORDER BY NATION.N_NATIONKEY DESC, REGION.R_REGIONKEY ASC;
