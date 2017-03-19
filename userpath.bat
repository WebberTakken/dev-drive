@Echo Off

::call function according to first argument
if not "%~1" == "" if not "%~2" == "" (
  call :LabelExists "%~1" && call :%~1 %~2 || goto Usage
) else goto Usage

:Exit
EXIT /B %ErrorLevel%

:Usage
echo Usage: userpath.bat [add] [YourValue]
goto Exit

:LabelExists
for /f "delims=" %%t in (
	'forfiles /p "%~dp0." /m "%~nx0" /c "cmd /d /c @echo 0x09"'
) do (
	findstr /i /m /r /c:"^[^:]*[ %%t]*:%~1[ %%t:;,=+]" /c:"^[^:]*[ %%t]*:%~1$" "%~f0" >nul 2>nul
)
Exit /b %ErrorLevel%

:Add - Add a variable to the PATH variable of the current user
SET NewValue=%~1
FOR /F "tokens=2*" %%a in ('REG QUERY HKCU\Environment\ /v path') DO echo.%%b | findstr /C:"%NewValue%">nul && (
   :: Value already exists in users PATH variable
   echo found %NewValue% in %%b
) || (
   :: Add new value to users PATH variable
   echo not found %NewValue% in %%b
   :: something like this
   ::reg add HKCU\Environment /v Path /t REG_EXPAND_SZ /d %SystemRoot:~0,3%php
   :: and then broadcast a settings change so that cli's and other apps can update
   :: see https://msdn.microsoft.com/en-gb/library/windows/desktop/ms725497.aspx
   ::WM_SETTINGCHANGE
       ::szEnv = "Environment";
       ::pEnv = &szEnv;
       ::SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, 0, pEnv);
)
Exit /b 0