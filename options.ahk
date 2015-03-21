options(){
	static list:={Virtual_Space:[2596,3],show_eol:2356,Show_Caret_Line:2096,show_whitespace:2021,word_wrap:2268,Hide_Indentation_Guides:2132,center_caret:[2403,0x15,75]}
	optionslist:=settings.sn("//Quick_Find_Settings/@*|//options/@*")
	while,ll:=optionslist.item[A_Index-1]
		v.options[ll.nodename]:=ll.text
	Show_EOL:
	Show_Caret_Line:
	Show_WhiteSpace:
	Word_Wrap:
	Center_Caret:
	Hide_Code_Explorer:
	Hide_Project_Explorer:
	Virtual_Space:
	Warn_Overwrite_On_Export:
	Disable_Backup:
	Disable_Autosave:
	Disable_Variable_List:
	Hide_Indentation_Guides:
	Show_Type_Prefix:
	Force_UTF8:
	Disable_Line_Status:
	sc:=csc()
	onoff:=settings.ssn("//options/@" A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	togglemenu(A_ThisLabel)
	v.options[A_ThisLabel]:=onoff
	sc[list[A_ThisLabel]](onoff)
	option:=settings.ssn("//options")
	ea:=settings.ea(option)
	for c,d in s.main{
		for a,b in ea{
			if !IsObject(List[a]){
				if(a="Hide_Indentation_Guides")
					b:=b?0:1
				d[list[a]](b)
			}Else if IsObject(List[a])&&b
				d[list[a].1](List[a].2,List[a].3)
			else if IsObject(List[a])&&onoff=0
				d[list[a].1](0)
		}
	}
	if (A_ThisLabel="Hide_Code_Explorer"||A_ThisLabel="Hide_Project_Explorer")
		resize()
	if(A_ThisLabel="Hide_Indentation_Guides")
		onoff:=onoff?0:1,sc[list[A_ThisLabel]](onoff)
	return
	onoff:=settings.ssn("//options/@" A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	return
	Highlight_Current_Area:
	Small_Icons:
	Enable_Close_On_Save:
	Autocomplete_Enter_Newline:
	Disable_Folders_In_Project_Explorer:
	Disable_Include_Dialog:
	onoff:=settings.ssn("//options/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	togglemenu(A_ThisLabel)
	if (A_ThisLabel="small_icons")
		return m("Requires that you restart Studio to take effect.")
	if (A_ThisLabel="Highlight_Current_Area"){
		if onoff
			hltline()
		Else
			sc:=csc(),sc.2045(2),sc.2045(3)
	}if(A_ThisLabel="Disable_Folders_In_Project_Explorer"){
		return m("Requires that you restart Studio to take effect.")
	}
	v.options[A_ThisLabel]:=onoff
	return
	;set bit only
	Check_For_Edited_Files_On_Focus:
	Auto_Advance:
	Auto_Set_Area_On_Quick_Find:
	Disable_Auto_Indent_For_Non_Ahk_Files:
	Auto_Close_Find:
	onoff:=settings.ssn("//options/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	v.options[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	togglemenu(A_ThisLabel)
	return
}