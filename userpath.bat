@Echo Off
::
:: File:        userpath.bat
::
:: Description: Adds variables to new or already existing PATH variable For current user
:: Author:      Webber
:: License:     MIT
::

:InputSanitation - Check If 2 arguments are set
If "%~1" == "" (
  Goto Usage
)
Set CurrentPath=%PATH%
Set ErrorLevel=
If Not "%~2" == "" (
  Call :LabelExists "%~1" && Call :%~1 %~2 || Goto Usage
) Else (
  Call :LabelExists "%~1" && Call :%~1 || Goto Usage
)
Goto Exit

:Usage - Show user how to run this programm
Echo Usage: userpath.bat [Command] [Value]
Echo Commands: [Add^|Reload]
Goto Exit

:LabelExists - Check if function is implemented
For /f "Delims=" %%t In (
	'Forfiles /p "%~dp0." /m "%~nx0" /c "cmd /d /c @Echo 0x09"'
) Do (
	Findstr /i /m /r /c:"^[^:]*[ %%t]*:%~1[ %%t:;,=+]" /c:"^[^:]*[ %%t]*:%~1$" "%~f0" >Nul 2>Nul
)
Goto Exit

:Add - Add a variable to the PATH variable of the current user
Echo. & Echo Adding to PATH Environment Variable for this user
Set NewValue=%~1
Goto CreateNew

:CreateNew - new PATH variable for user and add data to its value
Reg Query HKCU\Environment\ /v PATH >Nul 2>Nul
If %ErrorLevel% geq 1 (
  Set ErrorLevel=
  Reg Add HKCU\Environment\ /v PATH /t REG_EXPAND_SZ /d %NewValue%; >Nul
  Echo New PATH variable created and added %NewValue%
  Goto Reload
)
Goto AddToExisting

:AddToExisting - If PATH already exists, add new data to its value
For /F "tokens=2*" %%A In ('Reg Query HKCU\Environment\ /v PATH') Do Echo.%%B | FindStr /C:"%NewValue%" >Nul && (
   Echo %NewValue% already exists in %%B
   Goto Done
) || (
   Echo Adding %NewValue% to %%B
   Reg Delete HKCU\Environment\ /v PATH /f>Nul
   Reg Add HKCU\Environment\ /v PATH /t REG_EXPAND_SZ /d %NewValue%;%%B >Nul
)
Goto Reload

:Reload - Load machine and current user PATH variable for current session
:Refresh
Echo Reloading PATH Environment Variable
Set ErrorLevel=
Reg Query HKCU\Environment\ /v PATH >Nul 2>Nul
If %ErrorLevel% geq 1 (
  Set ErrorLevel=0
  Echo Nothing to update from user PATH variable.
  Goto Done
)
If Not "%NewValue%" == "" (
  Set NewValue=%NewValue%;
)
For /F "tokens=2*" %%A In ('Reg Query HKCU\Environment\ /v PATH') Do Set PATH=%NewValue%%CurrentPath% >Nul 2>Nul || Nul
Goto Done

:Done
Echo Done. & Echo.
Goto Exit

:Exit - Exit Session
Exit /b %ErrorLevel%