@Echo Off
::
:: File:        download.bat
::
:: Description: Attempts to download file using PowerShell or will revert back to deprecated bitsadmin to complete the task
:: Author:      Webber
:: License:     MIT
::

:InputSanitation
if not "%~1" == "" if not "%~2" == "" (
  call :download %~1 %~2
) else (
  goto Usage
)
goto Exit

:Usage
echo Invalid number of parameters, Usage: & echo.
echo download.bat path/to/resource path/to/destination
goto Exit

:Download
Set ErrorLevel=
"%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe" -command "exit $PSVersionTable.PSVersion.Major"
set PowerShellVer=%ErrorLevel%
set ErrorLevel=
if %PowerShellVer% geq 2 (
  "%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe" -command "Start-BitsTransfer -Source %~1 -Destination %~dp0\%~2"
) else (
  BitsAdmin /transfer "Downloading PHP" /download /priority normal %~1  %~dp0\%~2
)
goto Exit

:Exit
Exit /b %ErrorLevel%