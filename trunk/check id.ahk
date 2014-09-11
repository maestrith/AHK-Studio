check_id(id){
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	http.Open("GET","https://api.github.com/gists/" id "/star")
	http.SetRequestHeader("Authorization","Bearer " access_token)
	http.send(),code:=http.ResponseText
	http:=""
	if InStr(code,"not found")
		return
	return id
}