SET HEAD OFF
SET TERM OFF
SET ECHO OFF
SET FEEDBACK OFF
SET TRIMSPOOL ON
SET COLSEP ";"
spool ${ficdata}
set linesize 2000;
select 
TO_CHAR(PLAT_CODE),
TO_CHAR(PLAT_LIBEL),
TO_CHAR(GEO_LIBEL)
from
G2R4_PLATEAU,
G2R4_GEO
WHERE
G2R4_PLATEAU.GEO_ID = G2R4_GEO.GEO_CODE
  ; 
spool off
