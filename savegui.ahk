SaveGUI(win:=1){
	WinGet,max,MinMax,% hwnd([win])
	info:=winpos(win)
	if(!top:=settings.ssn("//gui/position[@window='" win "']"))
		top:=settings.Add("gui/position",{window:win},,1)
	text:=max?top.text:info.text,top.text:=text,top.SetAttribute("max",max)
}