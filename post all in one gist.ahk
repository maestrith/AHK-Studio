post_all_in_one_gist(info=""){
	url:="https://api.github.com/gists"
	info:=info?info:publish(1)
	get_access()
	file:=ssn(current(1),"@file").text
	id:=positions.ssn("//main[@file='" file "']/@id").text
	SplitPath,file,filename
	info:=RegExReplace(info,"([" Chr(34) "\\])","\$1")
	for a,b in {"`n":"\n","`t":"\t","`r":""}
		StringReplace,info,info,%a%,%b%,All
	desc=Posted using AHK Studio
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	if proxy:=settings.ssn("//proxy").text
		http.setProxy(2,proxy)
	json={"description":"%desc%","public":true,"files":{"%filename%":{"content":"%info%"}}}
	check_id(id)
	if id
		http.Open("PATCH",url "/" id)
	else
		http.Open("POST",url)
	if access_token
		http.SetRequestHeader("Authorization","Bearer " access_token)
	http.send(json)
	codes:=http.ResponseText
	split:=http.option(1)
	SplitPath,split,fname
	for a,b in ["html_url","id"]{
		split=":"
		RegExMatch(codes,"U)" b split "(.*)" chr(34),found)
		if b=html_url
			clipboard:=RegExReplace(found1,"\\")
		else
			id:=found1
	}
	if id{
		positions.unique({path:"main",att:{file:file,id:id},check:"file"})
		TrayTip,AHK Studio,Gist URL coppied to Clipboard,1
	}
	else
		m("Something went wrong.  Here is what the server sent back","","",codes)
}