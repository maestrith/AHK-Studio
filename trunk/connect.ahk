connect(){
	ScriptPath:=A_ScriptDir
	if debug.socket{
		debug.Send("detatch")
		sleep,500
		debug.disconnect()
		sleep,500
	}
	setup(13)
	Gui,Add,ListView,w600 h300 gdebugconnect,Processes
	for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process"){
		prog:=Trim(StrSplit(process.CommandLine,Chr(34)).4,Chr(34))
		if (InStr(process.commandline,"autohotkey")&&prog!=A_ScriptFullPath&&prog)
			LV_Add("",prog)
	}
	Gui,13:Show,,Open Processes
	return
	debugconnect:
	Gui,13:Default
	Gui,13:ListView,SysListView321
	LV_GetText(scriptpath,A_EventInfo)
	ifWinExist %ScriptPath% ahk_class AutoHotkey
	{
		socket:=new debug()
		v.connect:=1
		PostMessage,DllCall("RegisterWindowMessage","str","AHK_ATTACH_DEBUGGER")
	}
	13GuiClose:
	13GuiEscape:
	hwnd({rem:13})
	return
}