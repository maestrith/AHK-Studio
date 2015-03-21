Check_For_Update(){
	static version
	;auto_version
	sub:=A_NowUTC
	sub-=A_Now,hh
	FileGetTime,time,%A_ScriptFullPath%
	time+=%sub%,hh
	url:="http://files.maestrith.com/AHK-Studio/AHK%20Studio.text",http:=ComObjCreate("WinHttp.WinHttpRequest.5.1"),http.Open("GET",url)
	if proxy:=settings.ssn("//proxy").text
		http.setProxy(2,proxy)
	FormatTime,time,%time%,ddd, dd MMM yyyy HH:mm:ss
	http.setRequestHeader("If-Modified-Since",time " GMT"),http.Send(),setup(55),info:=http.responsetext?http.responsetext:"Nothing new to download"
	Gui,Add,Edit,w500 h500 ReadOnly,%info%
	Disable:=info="Nothing new to download"?"Disabled":""
	RegExMatch(info,"Om`n)^(\d*)\.(\d*)\.(\d*)\.(\d*)$",found),ver:=StrSplit(A_AhkVersion,".")
	if(found.1){
		if !(found.1=ver.1&&ver.2>=found.2&&ver.3>=found.3){
			Gui,Add,Button,gdownloadahk,Download AHK
		}else
			Gui,Add,Button,gautoupdate %Disable%,Update
	}else
		Gui,Add,Button,gautoupdate %Disable%,Update
	Gui,Add,Button,x+5 gextrainfo,Changlog History
	Gui,Show,,AHK Studio Version %version%
	Sleep,200
	ControlSend,55:Edit1,^{Home}
	return
	downloadahk:
	Run,http://ahkscript.org/download
	return
	autoupdate:
	;auto_version
	save(),settings.save(1)
	SplitPath,A_ScriptName,,,ext,name
	studio:=URLDownloadToVar("http://files.maestrith.com/AHK-Studio/AHK Studio.ahk")
	if !InStr(studio,";download complete")
		return m("There was an error. Please contact maestrith@gmail.com if this error continues")
	FileMove,%A_ScriptName%,%name%%version%.ahk,1
	FileAppend,%studio%,%A_ScriptName%
	Run,%A_ScriptName%
	ExitApp
	return
	55GuiEscape:
	55GuiClose:
	hwnd({rem:55})
	return
	extrainfo:
	Run,https://github.com/maestrith/AHK-Studio/wiki/Version-Update-History
	return
}