Post_Multiple_Segment_Gist(){
	get_access()
	ea:=xml.ea(vversion.ssn("//*[@file='" ssn(current(1),"@file").text "']")),newver:=ea.version "." ea.increment
	fi:=sn(current(1),"file/@file"),file:=ssn(current(1),"@file").text
	id:=positions.ssn("//main[@file='" file "']/@multiple_id").text
	url:="https://api.github.com/gists"
	if id
		id:=check_id(id)
	SplitPath,file,filename
	desc=Posted using AHK Studio
	json={"description":"%desc%","public":true,"files":
	json.="{"
	udf:=update("get").1
	while,f:=fi.item(A_Index-1).text{
		SplitPath,f,filename
		info:=udf[f]
		if a_index=1
			info.=compile_main_gist(f)
		json.=json(info,filename)
		if (fi.length!=A_Index)
			json.=","
	}
	StringTrimRight,json,json,1
	json.="}}"
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	if proxy:=settings.ssn("//proxy").text
		http.setProxy(2,proxy)
	if id
		http.Open("PATCH",url "/" id)
	else
		http.Open("POST",url)
	http.SetRequestHeader("Authorization","Bearer " access_token)
	SplashTextOn,,50,Updating Gist,Please wait...
	http.send(json)
	codes:=http.ResponseText
	for a,b in ["html_url","id"]{
		split=":"
		RegExMatch(codes,"U)" b split "(.*)" chr(34),found)
		if b=html_url
			clipboard:=RegExReplace(found1,"\\")
		else
			id:=found1
	}
	SplashTextOff
	if (id){
		positions.unique({path:"main",att:{file:file,multiple_id:id},check:"file"})
		m("URL Coppied to clipboard")
	}
	else
		m("Something went wrong.  Here is what the server sent back","","",codes,http.GetAllResponseHeaders())
}