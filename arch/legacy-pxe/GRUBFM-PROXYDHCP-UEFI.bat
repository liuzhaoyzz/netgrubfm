echo off
mode con cols=50 lines=5
title=building......
taskkill /f /im pxesrv.exe
taskkill /f /im hfs.exe
cd /d %~dp0


:: 获取管理员权限运行批处理
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs" 1>nul 2>nul
exit /b
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" ) 1>nul 2>nul

(
echo [dhcp]
echo start=1
echo proxydhcp=1
echo httpd=0
echo bind=1
echo poolsize=998
echo root=%~dp0
echo filename=loadfmx64.efi.0
)>%~dp0\bin\config.INI
start "" /min %~dp0\bin\hfs.exe -c active=yes -a %~dp0\bin\myhfs.ini
for /f %%a in ('dir /b/a-d *.*') do start "" /min %~dp0\bin\hfs.exe %%a
start "" /min %~dp0\bin\hfs.exe  %~dp0\app
start ""  %~dp0\bin\pxesrv.exe
exit
