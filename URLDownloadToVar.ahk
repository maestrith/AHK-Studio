URLDownloadToVar(url){
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	http.Open("GET",url),http.Send()
	return http.ResponseText
}