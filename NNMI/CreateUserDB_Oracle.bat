@echo off

set TS_Name=%1
set DB_User=%TS_Name%
set DB_Password=%2
set DFile_Path=C:\app\datafiles\NA\
set DB_login=system
set DB_login_password=openview
set DB_SID=nmc


echo ******************************************************
echo Generate SQL file to creat tablespace and user 
echo ******************************************************

>"createDBuser.sql" (
       echo conn %DB_login%^/%DB_login_password% as sysdba;
	echo DECLARE
	echo   v_tb_exists NUMBER := 0;
	echo   v_user_exists NUMBER := 0;
	echo   v_result NUMBER := 0;
	echo BEGIN
	echo     BEGIN
	echo         SELECT COUNT^(^*^) INTO v_tb_exists FROM dba_tablespaces WHERE tablespace_name=upper^(^'%TS_Name%^'^);
	echo         IF ^(v_tb_exists ^>0^) THEN
	echo 		  EXECUTE IMMEDIATE ^'Alter tablespace %TS_Name% offline^';
	echo 		  EXECUTE IMMEDIATE ^'Drop tablespace %TS_Name% including contents and datafiles^';
	echo         END IF;
	echo         SELECT COUNT^(^*^) INTO v_user_exists FROM dba_users WHERE username=upper^(^'%DB_User%^'^);
	echo         IF ^(v_user_exists ^>0^) THEN
	echo              EXECUTE IMMEDIATE ^'Alter user %DB_User% account lock^';
	echo   		  FOR x in ^(^select sid, serial# from v$session where username=upper^(^'%DB_User%^'^) ^)
	echo 		  LOOP  
	echo 			EXECUTE IMMEDIATE ^(^'Alter system kill session ^'^'^' ^|^|  x.Sid ^|^| ^',^' ^|^| x.Serial# ^|^| ^'^'^' immediate' ^);  
	echo 		  END LOOP;  
	echo 		  dbms_lock.sleep ^( seconds =^> 20 ^); 
	echo		  EXECUTE IMMEDIATE ^'Drop user %DB_User% cascade^';
	echo         END IF;
 	echo       END;
	echo   EXECUTE IMMEDIATE ^'CREATE TABLESPACE %TS_Name% DATAFILE ^'^'%DFile_Path%%TS_Name%.dbf^'^' size 100M autoextend on maxsize unlimited^';
	echo   EXECUTE IMMEDIATE ^'Create user %DB_User% identified by "%DB_Password%" default tablespace %TS_Name%^';
	echo   EXECUTE IMMEDIATE ^'Grant connect,resource,dba to %DB_User%^';
 	echo END;
	echo /
	echo exit;
)

sqlplus %DB_login%/%DB_login_password%@%DB_SID% @createDBuser.sql

pause
