@Echo on
REM -*- bat -*-

:: usage cmd /c setup.bat

curl -O http://installer-bin.streambox.com/7z920.msi
curl -O http://installer-bin.streambox.com/7za.exe
curl -O http://installer-bin.streambox.com/autoit-v3-setup.exe
curl -O http://installer-bin.streambox.com/handle.exe
curl -O http://installer-bin.streambox.com/sed-4.2-1-dep.zip
curl -O http://installer-bin.streambox.com/sed-4.2-1-bin.zip

set nsis=nsis-2.46-setup.exe
curl -O http://installer-bin.streambox.com/%nsis%
cmd /c %nsis% /S

rem added unicode nsis which supports strings larger than 1024 bytes
rem http://code.google.com/p/unsis
set nsis=nsis-2.46-Unicode-setup.exe
curl -O http://installer-bin.streambox.com/%nsis%
cmd /c %nsis% /S

:: remove nsis from user path first
.\pathman /ru "%programfiles%\NSIS\Unicode"
.\pathman /ru "%programfiles%\NSIS"
.\pathman /ru "%programfiles(x86)%\NSIS"

:: add nsis to user path
.\pathman /au "%programfiles%\NSIS"
.\pathman /au "%programfiles(x86)%\NSIS"

if not exist "%SystemRoot%\system32\robocopy.exe" ( copy robocopy.exe "%SystemRoot%\system32" )

:: autoit install
cmd /c autoit-v3-setup.exe /S
.\pathman /ru "%programfiles%\AutoIt3\Aut2Exe"
.\pathman /ru "%programfiles(x86)%\AutoIt3\Aut2Exe"
.\pathman /ru "%programfiles(x86)%\AutoIt3"
.\pathman /au "%programfiles%\AutoIt3\Aut2Exe"
.\pathman /au "%programfiles(x86)%\AutoIt3\Aut2Exe"
.\pathman /au "%programfiles(x86)%\AutoIt3"

cmd /c msiexec /L*v %windir%\temp\7z_install.log /qn /I 7z920.msi

cd nsis-plugins && cmd /c setup.bat
cd ..

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
robocopy Graphics "%pf%\NSIS\Streambox\Graphics" /e /s
robocopy Icons "%pf%\NSIS\Streambox\Icons" /e /s

cmd /k "reg query hkcu\environment /v Path"
