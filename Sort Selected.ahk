Sort_Selected(){
	static newwin,text,del
	sc:=csc(),text:=sc.getseltext()
	if !Text
		return m("Please select some text first.")
	newwin:=new windowtracker(18)
	newwin.Add(["Edit,w200 vdel,,w","Button,x+10 gsortdel,Sort By Delimeter,x","Button,x+10 gsortbyslash,Sort By \,x","Edit,xm w500 h500 vtext,,wh","Button,greplace,Replace Selected,y"])
	StringReplace,text,text,`n,`r`n,All
	ControlSetText,Edit2,%text%,% hwnd([18])
	newwin.Show("Sort Selected")
	return
	sortbyslash:
	Sort,text,\
	StringReplace,text,text,`n,`r`n,all
	ControlSetText,Edit2,%text%,% hwnd([18])
	return
	sortdel:
	nw:=newwin[],del:=nw.del,text:=nw.text
	Sort,text,D%del%
	StringReplace,text,text,`n,`r`n,all
	ControlSetText,Edit2,%text%,% hwnd([18])
	return
	18GuiClose:
	18GuiEscape:
	hwnd({rem:18})
	return
	replace:
	text:=newwin[].text
	StringReplace,text,text,`r`n,`n,all
	csc().2170(0,text)
	hwnd({rem:18})
	return
}