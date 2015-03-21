Auto_Update(){
	sub:=A_NowUTC
	sub-=A_Now,hh
	FileGetTime,time,%A_ScriptFullPath%
	time+=%sub%,hh
	url:="http://files.maestrith.com/AHK-Studio/AHK%20Studio.text",http:=ComObjCreate("WinHttp.WinHttpRequest.5.1"),http.Open("GET",url)
	if proxy:=settings.ssn("//proxy").text
		http.setProxy(2,proxy)
	FormatTime,time,%time%,ddd, dd MMM yyyy HH:mm:ss
	http.setRequestHeader("If-Modified-Since",time " GMT"),http.Send(),new:=http.responsetext?1:0
	if new
		SetTimer,autoupdate,-1
	else
		m("Nothing new to download")
}