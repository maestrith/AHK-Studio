Check_For_Update(){
	static version
	version=;auto_version
	sub:=A_NowUTC
	sub-=A_Now,hh
	FileGetTime,time,%A_ScriptFullPath%
	time+=%sub%,hh
	url:="http://files.maestrith.com/AHK-Studio/AHK%20Studio.text"
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1"),http.Open("GET",url)
	FormatTime,time,%time%,ddd, dd MMM yyyy HH:mm:ss
	http.setRequestHeader("If-Modified-Since",time " GMT"),http.Send(),setup(55)
	info:=http.responsetext?http.responsetext:"Nothing new to download"
	Gui,Add,Edit,w500 h500 ReadOnly,%info%
	Gui,Add,Button,gautoupdate,Update
	Gui,Add,Button,x+5 gextrainfo,Changlog History
	Gui,Show,,AHK Studio Version %version%
	sleep,200
	ControlSend,55:Edit1,^{Home}
	return
	autoupdate:
	version=;auto_version
	save(),settings.save(1)
	SplitPath,A_ScriptName,,,ext,name
	studio:=URLDownloadToVar("http://files.maestrith.com/AHK-Studio/AHK Studio.ahk")
	if !InStr(studio,";download complete")
		return m("There was an error. Please contact maestrith@gmail.com if this error continues")
	FileMove,%A_ScriptName%,%name%%version%.ahk,1
	FileAppend,%studio%,%A_ScriptName% ;here
	Run,%A_ScriptName%
	ExitApp
	return
	55GuiEscape:
	55GuiClose:
	hwnd({rem:55})
	return
	extrainfo:
	Run,https://github.com/maestrith/AHK-Studio/wiki/Version-Update-History
	Return
}