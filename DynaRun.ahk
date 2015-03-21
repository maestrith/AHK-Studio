DynaRun(Script,debug=0){
	static exec
	exec.terminate()
	Name:="AHK Studio Test",Pipe:=[],cr:= Chr(34) Chr(96)"n" Chr(34)
	if !InStr(script,"m(x*){")
		script.="`n" "m(x*){`nfor a,b in x`nlist.=b " cr "`nMsgBox,,AHK Studio,% list`n}"
	if !InStr(script,"t(x*){")
		script.="`n" "t(x*){`nfor a,b in x`nlist.=b " cr "`nToolTip,% list`n}"
	Loop, 2
		Pipe[A_Index]:=DllCall("CreateNamedPipe","Str","\\.\pipe\" name,"UInt",2,"UInt",0,"UInt",255,"UInt",0,"UInt",0,"UPtr",0,"UPtr",0,"UPtr")
	Call:=Chr(34) A_AhkPath Chr(34) " /ErrorStdOut /CP65001 " Chr(34) "\\.\pipe\" Name Chr(34),Shell:=ComObjCreate("WScript.Shell"),Exec:=Shell.Exec(Call)
	for a,b in Pipe
		DllCall("ConnectNamedPipe","UPtr",b,"UPtr",0)
	FileOpen(Pipe[2],"h","UTF-8").Write(Script)
	for a,b in Pipe
		DllCall("CloseHandle","UPtr",b)
	return exec.processid
}