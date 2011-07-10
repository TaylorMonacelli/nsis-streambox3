!ifndef StreamboxNSISHelper_INCLUDED
!define StreamboxNSISHelper_INCLUDED

!include NSISpcre.nsh

# !insertmacro REMatches
!insertmacro RESetOption
!insertmacro REMatches


!macro determinIfWriteProtectIsOn

	##############################
	# determine if write protect is on/off
	##############################
	GetTempFileName $0
	nsExec::ExecToStack '"$SYSDIR\cmd" /c \
		$SYSDIR\fbwfmgr.exe /displayconfig 2>&1 > $0' $1
# File-based write filter is not enabled for the current session.

	ClearErrors
	FileOpen $2 $0 r #$2 is file handle
	IfErrors done
	# I assume first line is current state (such as "File-based write filter configuration for the current session:)
	FileRead $2 $3 
	# I assume second line describes fbwf sate of current session (for example "    filter state: enabled."
	FileRead $2 $3 
#  RECaptureMatches RESULT PATTERN SUBJECT PARTIAL
	${RECaptureMatches} $R1 "(.*enabled)" "$3" 1
	${If} $R1 > 0
			FileOpen $R1 $WINDIR\temp\disable_write_protect_for_install.bat  w
					FileWrite $R1 '\
@echo off$\r$\n\
ECHO Write Protect OFF$\r$\n\
ECHO This will allow files on the System Drive to be changed$\r$\n\
ECHO.$\r$\n\
ECHO.$\r$\n\
SET /p choice=This will require a system restart, do you want to continue? (Y/N)$\r$\n\
$\r$\n\
IF "%choice%"=="y" GOTO do$\r$\n\
IF "%choice%"=="Y" GOTO do$\r$\n\
IF "%choice%"=="yes" GOTO do$\r$\n\
IF "%choice%"=="Yes" GOTO do$\r$\n\
GOTO notdo$\r$\n\
$\r$\n\
:do$\r$\n\
ECHO Restarting, please wait....$\r$\n\
$WINDIR\system32\fbwfmgr.exe /disable$\r$\n\
set link=%ALLUSERsPROFILE%\Desktop\Disable Write Protect.lnk$\r$\n\
if exist "%link%" ( del /q "%link%" )$\r$\n\
shutdown -r -t 00$\r$\n\
exit$\r$\n\
$\r$\n\
:notdo$\r$\n\
ECHO Operation aborted. Press any key to exit...$\r$\n\
PAUSE$\r$\n\
exit$\r$\n\
$\r$\n\
'
			FileClose $R1
			SetShellVarContext all
			CreateShortCut "$DESKTOP\Disable Write Protect.lnk" $WINDIR\temp\disable_write_protect_for_install.bat
		MessageBox MB_ICONSTOP \
		"I can't continue with FBWF write filter turned on.  In order to continue, you must disable the \
			drive write protect, reboot and retry the install.   In order to disable drive write protect \
			you can run the $\"Disable Write Protect$\" shortcut on the desktop."
		Abort
	${EndIf}
	FileClose $2
	done:

!macroend


##############################
# KillRunningStreamboxApps
##############################

!macro KillRunningStreamboxApps Un
	Function ${un}KillRunningStreamboxApps

		;Copy taskill to system directory if not available
		IfFileExists $SYSDIR\taskkill.exe +2
			File /oname=$SYSDIR\taskkill.exe nsis-streambox2\taskkill.exe

		##############################
		# kill running apps
		##############################
		DetailPrint "Searching for process 'cmd.exe'"
		FindProcDLL::FindProc "cmd.exe"
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping cmd.exe application"
		nsExec::ExecToStack '$SYSDIR\taskkill.exe /F /IM cmd.exe'
		Pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'QTInfo.exe'"
		FindProcDLL::FindProc QTInfo.exe
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping QTInfo.exe"
		nsExec::ExecToStack "taskkill /F /IM QTInfo.exe"
		pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'SMSMonitor.exe'"
		FindProcDLL::FindProc SMSMonitor.exe
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox SMSMonitor.exe application"
		nsExec::ExecToStack "taskkill /F /IM SMSMonitor.exe"
		pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'sms1.exe'"
		FindProcDLL::FindProc sms1.exe
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox sms1.exe application"
		nsExec::ExecToStack "taskkill /F /IM sms1.exe"
		pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'sms.exe'"
		FindProcDLL::FindProc sms.exe
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox sms.exe application"
		nsExec::ExecToStack "taskkill /F /IM sms.exe"
		pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'QuickTimePlayer.exe'"
		FindProcDLL::FindProc QuickTimePlayer.exe
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping QuickTimePlayer.exe"
		nsExec::ExecToStack "taskkill /F /IM QuickTimePlayer.exe"
		pop $0
		sleep 2000
		
		
		# just to be sure, run cmd.exe kill again!
		DetailPrint "Searching for process 'cmd.exe'"
		FindProcDLL::FindProc "cmd.exe"
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping cmd.exe application"
		nsExec::ExecToStack '$SYSDIR\taskkill.exe /F /IM cmd.exe'
		Pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'Encoder3D.exe'"
		FindProcDLL::FindProc "Encoder3D.exe"
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox Encoder3D.exe application"
		nsExec::ExecToStack '$SYSDIR\taskkill.exe /F /IM Encoder3D.exe'
		Pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'Transport3D.exe'"
		FindProcDLL::FindProc "Transport3D.exe"
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox Transport3D.exe application"
		nsExec::ExecToStack '$SYSDIR\taskkill.exe /F /IM Transport3D.exe'
		Pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'Transport.exe'"
		FindProcDLL::FindProc "Transport.exe"
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox Decoder application"
		nsExec::ExecToStack '$SYSDIR\taskkill.exe /F /IM Transport.exe'
		Pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'transportSD-LS32.exe'"
		FindProcDLL::FindProc "transportSD-LS32.exe"
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox Decoder application"
		nsExec::ExecToStack '$SYSDIR\taskkill.exe /F /IM transportSD-LS32.exe'
		Pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'transportSD-LH32.exe'"
		FindProcDLL::FindProc "transportSD-LH32.exe"
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox Decoder application"
		nsExec::ExecToStack '$SYSDIR\taskkill.exe /F /IM transportSD-LH32.exe'
		Pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'transportHD-LH32.exe'"
		FindProcDLL::FindProc "transportHD-LH32.exe"
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox Decoder application"
		nsExec::ExecToStack '$SYSDIR\taskkill.exe /F /IM transportHD-LH32.exe'
		Pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'TransportHD32k.exe'"
		FindProcDLL::FindProc "TransportHD32k.exe"
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox Decoder application"
		nsExec::ExecToStack '$SYSDIR\taskkill.exe /F /IM TransportHD32k.exe'
		Pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'TransportSD-LH32.exe'"
		FindProcDLL::FindProc "TransportSD-LH32.exe"
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox Decoder application"
		nsExec::ExecToStack '$SYSDIR\taskkill.exe /F /IM TransportSD-LH32.exe'
		Pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'EncoderFD1_3_32p4-sd.exe'"
		FindProcDLL::FindProc "EncoderFD1_3_32p4-sd.exe"
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox SD/HD Encoder application"
		nsExec::ExecToStack '$SYSDIR\taskkill.exe /F /IM EncoderFD1_3_32p4-sd.exe'
		Pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'EncoderFD1_3_32p4-hd.exe'"
		FindProcDLL::FindProc "EncoderFD1_3_32p4-hd.exe"
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox HD Encoder application"
		nsExec::ExecToStack '$SYSDIR\taskkill.exe /F /IM EncoderFD1_3_32p4-hd.exe'
		Pop $0
		sleep 2000
		
		DetailPrint "Searching for process 'EncoderFD1_3.exe'"
		FindProcDLL::FindProc "EncoderFD1_3.exe"
		IntCmp $R0 1 0 +5
		DetailPrint "Stopping Streambox SD Encoder application"
		nsExec::ExecToStack '$SYSDIR\taskkill.exe /F /IM EncoderFD1_3.exe'
		Pop $0
		sleep 2000
		##############################
		# end kill running apps
		##############################
	FunctionEnd
!macroend

!endif


# Emacs vars
# Local Variables: ***
# comment-column:0 ***
# tab-width: 2 ***
# comment-start:"# " ***
# End: ***
