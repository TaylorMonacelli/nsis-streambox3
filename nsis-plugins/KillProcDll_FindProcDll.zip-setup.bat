REM -*- bat -*-
@Echo on

set plugin=KillProcDll_FindProcDll
set zip=%plugin%.zip
set stage=%cd%\%zip%-odXihBhRVpA4

mkdir "%stage%"
.\unzip -q -n "KillProcDll_FindProcDll.zip" -d "%stage%"

cd "%programfiles%\NSIS"

REM keep unicode bits separte from non-unicode bits.  therefor commenting this out:
REM if exist Unicode\Plugins\nul (
REM 	copy /y "%stage%\KillProcDLL.dll" "%programfiles%\NSIS\Unicode\Plugins"
REM )

if exist Plugins\nul (
	copy /y "%stage%\KillProcDLL.dll" "%programfiles%\NSIS\Plugins"
)

rmdir /q/s "%stage%"