options(){
	static list:={Virtual_Space:[2596,3],show_eol:2356,Show_Caret_Line:2096,show_whitespace:2021,word_wrap:2268,center_caret:[2403,0x15,75]}
	list:=settings.sn("//Quick_Find_Settings/@*|//options/@*")
	while,ll:=list.item[A_Index-1]
		v.options[ll.nodename]:=ll.text
	Show_EOL:
	Show_Caret_Line:
	Show_WhiteSpace:
	Word_Wrap:
	Center_Caret:
	Hide_Code_Explorer:
	Hide_Project_Explorer:
	Virtual_Space:
	sc:=csc()
	onoff:=settings.ssn("//options/@" A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	togglemenu(A_ThisLabel)
	v.options[A_ThisLabel]:=onoff
	sc[list[A_ThisLabel]](onoff)
	option:=settings.ssn("//options")
	ea:=settings.ea(option)
	for c,d in s.main
		for a,b in ea
		if !IsObject(List[a]){
			d[list[a]](b)
	}Else if IsObject(List[a])&&b
	d[list[a].1](List[a].2,List[a].3)
	else if IsObject(List[a])&&onoff=0
		d[list[a].1](0)
	if (A_ThisLabel="Hide_Code_Explorer"||A_ThisLabel="Hide_Project_Explorer")
		Resize()
	return
	onoff:=settings.ssn("//options/@" A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	return
	Highlight_Current_Area:
	Small_Icons:
	Enable_Close_On_Save:
	Autocomplete_Enter_Newline:
	onoff:=settings.ssn("//options/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	togglemenu(A_ThisLabel)
	if (A_ThisLabel="small_icons")
		Return m("Requires a reboot to take effect.")
	if (A_ThisLabel="Highlight_Current_Area"){
		if onoff
			hltline()
		Else
			sc:=csc(),sc.2045(2),sc.2045(3)
	}
	v.options[A_ThisLabel]:=onoff
	return
	;set bit only
	Auto_Set_Area_On_Quick_Find:
	onoff:=settings.ssn("//options/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	v.options[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	togglemenu(A_ThisLabel)
	return
}