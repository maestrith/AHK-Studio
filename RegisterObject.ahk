ObjRegisterActive(Object,CLSID:="{DBD5A90A-A85C-11E4-B0C7-43449580656B}",Flags:=0){ ;http://ahkscript.org/boards/viewtopic.php?f=6&t=6148
	static cookieJar:={}
	if(!CLSID){
		if(cookie:=cookieJar.Remove(Object))!=""
			DllCall("oleaut32\RevokeActiveObject","uint",cookie,"ptr",0)
		return
	}
	if cookieJar[Object]
		throw Exception("Object is already registered",-1)
	VarSetCapacity(_clsid,16,0)
	if (hr:=DllCall("ole32\CLSIDFromString","wstr",CLSID,"ptr",&_clsid))<0
		return
	hr:=DllCall("oleaut32\RegisterActiveObject","ptr",&Object,"ptr",&_clsid,"uint",Flags,"uint*",cookie,"uint")
	if hr<0
		return
	cookieJar[Object]:=cookie
}