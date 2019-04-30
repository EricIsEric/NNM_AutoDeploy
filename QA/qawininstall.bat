set qabuildpath=%1
set db_type=%2
set db_user=%3
::set qainstallpath=C:\Program Files (x86)\HP\HP BTO Software\Uninstall\HPOvQAiSPI
if exist "C:\Program Files (x86)\HP\HP BTO Software\Uninstall\HPOvQAiSPI\setup.exe" (
"C:\Program Files (x86)\HP\HP BTO Software\Uninstall\HPOvQAiSPI\setup.exe" -i silent
)
%WORKSPACE%\wget\wget.exe -r -nd -np -l 1 -A "NMC-NNMi-Perf-QA*.zip" %qabuildpath%
rd /q /s C:\qaspi
"C:\Program Files\7-Zip\7z.exe" x NMC-NNMi-Perf-QA*.zip -oC:\qaspi
if /i "%db_type:~0,1%"=="E" (
copy /y "C:\qaspi\QAiSPI_WinNT4.0\silentInstall.properties" %TEMP%\..
copy /y "C:\qaspi\QAiSPI_WinNT4.0\silentInstall.properties" %TEMP%\
)
::need to update later
if /i "%db_type:~0,1%"=="O" (
copy /y %WORKSPACE%\ovinstallparams_oracle.ini %TEMP%\..
cd %TEMP%\..
for /f "tokens=*" %%i in (ovinstallparams_oracle.ini) do (
if "%%i"=="db.user.loginname=" (
echo %%i%db_user%>>ovinstallparams.ini
) else (
echo %%i>>ovinstallparams.ini)
)
)
"C:\Program Files (x86)\HP\HP BTO Software\bin\ovstart.exe" -v
cd C:\qaspi
"C:\qaspi\QAiSPI_WinNT4.0\setup.exe" -i silent
"C:\Program Files (x86)\HP\HP BTO Software\bin\ovstart.exe" -c qajboss
"C:\Program Files (x86)\HP\HP BTO Software\bin\ovstatus.exe" -v