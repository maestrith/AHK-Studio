options(x:=0){
	static list:={Virtual_Space:[2596,3],show_eol:2356,Show_Caret_Line:2096,show_whitespace:2021,word_wrap:2268,Hide_Indentation_Guides:2132,center_caret:[2403,15,75]}
	static main:="Center_Caret,Disable_Auto_Complete,Disable_Auto_Complete_While_Tips_Are_Visible,Disable_Autosave,Disable_Backup,Disable_Line_Status,Disable_Variable_List,Disable_Word_Wrap_Indicators,Force_Utf8,Hide_Code_Explorer,Hide_File_Extensions,Hide_Indentation_Guides,Hide_Project_Explorer,Remove_Directory_Slash,Show_Caret_Line,Show_EOL,Show_Type_Prefix,Show_WhiteSpace,Virtual_Space,Warn_Overwrite_On_Export,Word_Wrap,Run_As_Admin"
	static next:="Auto_Space_After_Comma,Autocomplete_Enter_Newline,Disable_Auto_Delete,Disable_Auto_Insert_Complete,Disable_Folders_In_Project_Explorer,Disable_Include_Dialog,Enable_Close_On_Save,Full_Tree,Highlight_Current_Area,Manual_Continuation_Line,Small_Icons,Top_Find"
	static bit:="Auto_Advance,Auto_Close_Find,Auto_Set_Area_On_Quick_Find,Build_Comment,Check_For_Edited_Files_On_Focus,Disable_Auto_Indent_For_Non_Ahk_Files,Full_Backup_All_Files"
	if(x)
		return {main:main,next:next,bit:bit}
	optionslist:=settings.sn("//Quick_Find_Settings/@*|//options/@*")
	while,ll:=optionslist.item[A_Index-1]
		v.options[ll.nodename]:=ll.text
	Center_Caret:
	Disable_Auto_Complete:
	Disable_Auto_Complete_While_Tips_Are_Visible:
	Disable_Autosave:
	Disable_Backup:
	Disable_Line_Status:
	Disable_Variable_List:
	Disable_Word_Wrap_Indicators:
	Force_Utf8:
	Hide_Code_Explorer:
	Hide_File_Extensions:
	Hide_Indentation_Guides:
	Hide_Project_Explorer:
	Remove_Directory_Slash:
	Show_Caret_Line:
	Show_EOL:
	Show_Type_Prefix:
	Show_WhiteSpace:
	Virtual_Space:
	Warn_Overwrite_On_Export:
	Word_Wrap:
	Run_As_Admin:
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
				if(a="Disable_Word_Wrap_Indicators")
					d.2460(b?0:4)
			}Else if IsObject(List[a])&&b
				d[list[a].1](List[a].2,List[a].3)
			else if IsObject(List[a])&&onoff=0
				d[list[a].1](0)
		}
	}
	if (A_ThisLabel="Hide_Code_Explorer"||A_ThisLabel="Hide_Project_Explorer")
		Resize("rebar")
	if(A_ThisLabel="Hide_Indentation_Guides")
		onoff:=onoff?0:1,sc[list[A_ThisLabel]](onoff)
	if(A_ThisLabel="Disable_Word_Wrap_Indicators")
		onoff:=onoff?0:3,sc[list[A_ThisLabel]](onoff)
	if(A_ThisLabel="Hide_File_Extensions"||A_ThisLabel=""){
		fl:=files.sn("//file")
		Gui,1:Default
		Gui,1:TreeView,SysTreeView321
		GuiControl,1:-Redraw,SysTreeView321
		while,ff:=fl.item[A_Index-1],ea:=xml.ea(ff){
			name:=ea.file
			SplitPath,name,filename,,,nne
			name:=v.options.Hide_File_Extensions?nne:filename,ff.SetAttribute("filename",name),TV_Modify(ea.tv,"",name)
		}
		GuiControl,1:+Redraw,SysTreeView321
	}if(A_ThisLabel="Remove_Directory_Slash")
		Refresh_Project_Explorer()
	if(A_ThisLabel="margin_left")
		csc().2155(0,6)
	
	return
	onoff:=settings.ssn("//options/@" A_ThisLabel).text?0:1,att:=[],att[A_ThisLabel]:=onoff,settings.add({path:"options",att:att})
	return
	Auto_Space_After_Comma:
	Autocomplete_Enter_Newline:
	Disable_Auto_Delete:
	Disable_Auto_Insert_Complete:
	Disable_Folders_In_Project_Explorer:
	Disable_Include_Dialog:
	Enable_Close_On_Save:
	Full_Tree:
	Highlight_Current_Area:
	Manual_Continuation_Line:
	Small_Icons:
	Top_Find:
	onoff:=settings.ssn("//options/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	togglemenu(A_ThisLabel)
	if(A_ThisLabel="small_icons")
		return m("Requires that you restart Studio to take effect.")
	if(A_ThisLabel="Highlight_Current_Area"){
		if onoff
			hltline()
		Else
			sc:=csc(),sc.2045(2),sc.2045(3)
	}
	if(A_ThisLabel="top_find")
		resize("rebar")
	v.options[A_ThisLabel]:=onoff
	if(A_ThisLabel~="i)Disable_Folders_In_Project_Explorer|Full_Tree")
		Refresh_Project_Explorer()
	return
	;set bit only
	Auto_Advance:
	Auto_Close_Find:
	Auto_Set_Area_On_Quick_Find:
	Build_Comment:
	Check_For_Edited_Files_On_Focus:
	Disable_Auto_Indent_For_Non_Ahk_Files:
	Full_Backup_All_Files:
	onoff:=settings.ssn("//options/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff,v.options[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	togglemenu(A_ThisLabel)
	return
}