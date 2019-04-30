@echo off

set nnmiftpserver=%1
set db_type=%2
set db_user=%3
set db_user_loginpassword=z4qhGfyWsQc0fUVbHXgx3FELM4LpiMqa
set File=%TEMP%\..\ovinstallparams.ini

SET db_host=15.115.176.170
SET db_instance=nmc
SET uninstaller="C:\Program Files (x86)\HP\HP BTO Software\Uninstall\NNM\setup.exe"
SET NNMi_HOME="C:\Program Files (x86)\HP"

:uninstall
if exist %uninstaller% (
	echo ******Uninstall if exit******
	call %uninstaller% -i silent
	if ERRORLEVEL 0 (
		echo " NNMi is uninstalled successfully"
		rd /s/q %TEMP%\..\
		rd /s/q %programdata%\HP\
		rd /s/q %NNMi_HOME%
	)else (
		echo " Failed to uninstall NNMi"
		goto exit
	)
)

echo ******Download build******
rem %WORKSPACE%\wget\wget.exe -r -nd -np -l 1 -A "NN*.zip" %nnmiftpserver%


echo ******Extract build******
rem call 7z.exe x NN*.zip -oC:\nnmi -aoa


if /i "%db_type:~0,1%"=="E" (
	echo ******Generate params file for Embedded DB******
	>"%File%" (
		echo [obs.install]
		echo db.embedded=Solid
		echo [nonOV.JBoss]
		echo httpport=8004
		echo.
		echo [installer.properties]
		echo setup=NNM
		echo.
	)
)


if /i "%db_type:~0,1%"=="O" (
	echo ******Generate params file for Oracle DB******
	>"%File%" (
		echo [obs.install]
		echo db.oracle.tablestbsp.create.initsize=100M
		echo db.databasesystem=Oracle ^(Thin^)
		echo db.host=%db_host%
		echo db.oracle.temptbsp.create.initsize=10M
		echo db.instance=%db_instance%
		echo db.port=1521
		echo db.oracle.indextbsp.create.sizestep=5M
		echo db.oracle.indextbsp.create.initsize=50M
		echo db.user.loginname=%db_user%
		echo db.user.loginpassword=%db_user_loginpassword%
		echo.
		echo [nonOV.JBoss]
		echo httpport=8004
		echo.
		echo [installer.properties]
		echo setup=NNM
		echo.
	)
)


echo ******Start installation******
call "C:\nnmi\setup.exe" -i silent
call "C:\Program Files (x86)\HP\HP BTO Software\bin\ovstart.exe" -v
call "C:\Program Files (x86)\HP\HP BTO Software\bin\ovstatus.exe" -v

:exit
pause
