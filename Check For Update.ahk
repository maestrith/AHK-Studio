Check_For_Update(){
	static version,edit
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
	if(http.ResponseText)
		file:=FileOpen("changelog.txt","rw"),file.seek(0),file.write(RegExReplace(http.ResponseText,"\R","`r`n")),file.length(file.position)
	Gui,Add,Edit,w500 h500 ReadOnly hwndedit,%info%
	Disable:=info="Nothing new to download"?"Disabled":""
	Gui,Add,Button,gautoupdate,Update
	Gui,Add,Button,x+5 gcurrentinfo,Current Changelog
	Gui,Add,Button,x+5 gextrainfo,Changelog History
	Gui,Show,,AHK Studio Version %version%
	SendMessage,0xB1,0,0,,ahk_id%edit%
	return
	downloadahk:
	Run,http://ahkscript.org/download
	return
	currentinfo:
	file:=FileOpen("changelog.txt","rw")
	if(!file.length)
		file:=FileOpen("changelog.txt","rw"),file.seek(0),file.write(RegExReplace(UrlDownloadToVar("http://files.maestrith.com/AHK-Studio/AHK Studio.text"),"\R","`r`n")),file.length(file.position)
	file.seek(0)
	ControlSetText,Edit1,% file.Read(file.length)
	return
	autoupdate:
	;auto_version
	save(),settings.save(1)
	SplitPath,A_ScriptName,,,ext,name
	studio:=URLDownloadToVar("http://files.maestrith.com/AHK-Studio/AHK Studio.ahk")
	if !InStr(studio,";download complete")
		return m("There was an error. Please contact maestrith@gmail.com if this error continues")
	FileMove,%A_ScriptName%,%name%%version%.ahk,1
	File:=FileOpen(A_ScriptDir "\" A_ScriptName,"rw")
	File.seek(0),File.write(studio),File.length(File.position)
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