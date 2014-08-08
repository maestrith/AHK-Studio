Sort_Selected(){
	static text,del
	sc:=csc(),text:=sc.getseltext()
	if !Text
		return m("Please select some text first.")
	setup(18)
	Gui,Add,Edit,w200 vdel
	Gui,Add,Button,x+10 gsortdel,Sort By Delimeter
	Gui,Add,Button,xm gsortbyslash,Sort By \
	Gui,Add,Edit,w500 h500,%text%
	Gui,Add,Button,greplace,Replace Selected
	Gui,Show,,Sort Selected
	return
	sortbyslash:
	Sort,text,\ ;%del%
	StringReplace,text,text,`n,`r`n,all
	ControlSetText,Edit2,%text%,% hwnd([18])
	Return
	sortdel:
	Gui,18:Submit,Nohide
	Sort,text,D%del%
	StringReplace,text,text,`n,`r`n,all
	ControlSetText,Edit2,%text%,% hwnd([18])
	return
	18GuiClose:
	18GuiEscape:
	hwnd({rem:18})
	replace:
	Gui,18:Submit
	StringReplace,text,text,`r`n,`n,all
	csc().2170(0,text)
	hwnd({rem:18})
	Return
}