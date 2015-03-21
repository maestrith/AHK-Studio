savegui(){
	WinGet,max,MinMax,% hwnd([1])
	info:=Resize("get"),text:=max?settings.ssn("//gui/position[@window='1']").text:info,top:=settings.ssn("//gui/position[@window='1']")
	if !top.text
		top:=settings.add2("gui/position",{window:1})
	if (IsObject(text)=0&&text!="")
		top.text:=text
	top.SetAttribute("max",max)
}