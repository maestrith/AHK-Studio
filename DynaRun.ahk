DynaRun(TempScript,debug=0){
	;http://www.autohotkey.com/community/viewtopic.php?t=63916
	if RegExMatch(tempscript,"i)(SetWorkingDir.+)",found){
		FileCreateDir,temp
		tempscript:=RegExReplace(tempscript,"i)(SetWorkingDir.+)","SetWorkingDir," A_ScriptDir "\temp",count,1)
	}else
	tempscript:="SetWorkingDir," A_ScriptDir "\temp`r`n" tempscript
	StringReplace,TempScript,TempScript,`r`n,`n,All
	if (debug=1){
		if debug.socket
			return m("Program running already"),debug.disconnect()
		sock:=new debug()
		if sock<0
			return m("something happened")
		for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
			if instr(process.commandline,"pipe")&&instr(process.commandline,a_ahkpath)
				Process,Close,% "ahk_pid" process.processid
	}
	static _:="uint"
	@:=A_PtrSize?"Ptr":_
	name:="AHK Studio Test"
	pipe_ga:= DllCall("CreateNamedPipe","str","\\.\pipe\" name,_,2,_,0,_,255,_,0,_,0,@,0,@,0)
	pipe:= DllCall("CreateNamedPipe","str","\\.\pipe\" name,_,2,_,0,_,255,_,0,_,0,@,0,@,0)
	if (pipe=-1 or pipe_ga=-1)
		Return 0
	db:=debug=1?"/debug":""
	Run, %A_AhkPath% %db% "\\.\pipe\%name%",,UseErrorLevel HIDE, PID
	If ErrorLevel
		MsgBox, 262144, ERROR,% "Could not open file:`n" __AHK_EXE_ """\\.\pipe\" name """"
	DllCall("ConnectNamedPipe",@,pipe_ga,@,0)
	DllCall("CloseHandle",@,pipe_ga)
	DllCall("ConnectNamedPipe",@,pipe,@,0)
	script:=(A_IsUnicode ? chr(0xfeff) : (chr(239) . chr(187) . chr(191))) . TempScript
	if !DllCall("WriteFile",@,pipe,"str",script,_,(StrLen(script)+1)*(A_IsUnicode ? 2 : 1),_ "*",0,@,0)
		Return A_LastError
	DllCall("CloseHandle",@,pipe)
	SetWorkingDir,%A_ScriptDir%
	Return PID
}