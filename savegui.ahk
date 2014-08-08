savegui(){
	WinGet,max,MinMax,% hwnd([1])
	text:=max
	text:=max?settings.ssn("//gui/position[@window='1']").text:resize("get")
	top:=settings.ssn("//gui/position[@window='1']")
	if !top.text
		top:=settings.add({path:"gui/position",att:{window:1}})
	top.text:=text
	top.SetAttribute("max",max)
}