REM -*- bat -*-
@Echo on

set zip=NSISpcre.zip
set stage=%cd%\%zip%-odXihBhRVpA4

mkdir "%stage%"
.\unzip -q -n "%zip%" -d "%stage%"

cd "%programfiles%\NSIS"

if exist Unicode\Plugins\nul (
	copy /y "%stage%\NSISpcre.dll" "Unicode\Plugins"
	copy /y "%stage%\NSISpcre.nsh" "Unicode\Include"

)

if exist Plugins\nul (
	copy /y "%stage%\NSISpcre.dll" "Plugins"
	copy /y "%stage%\NSISpcre.nsh" "Include"
)

rmdir /q/s "%stage%"