SELECT NATION.N_REGIONKEY, REGION.R_REGIONKEY FROM REGION JOIN NATION ON NATION.N_REGIONKEY=REGION.R_REGIONKEY WHERE REGION.R_NAME = '95' AND REGION.R_REGIONKEY > 27791.61 ORDER BY NATION.N_REGIONKEY DESC, REGION.R_REGIONKEY DESC;
