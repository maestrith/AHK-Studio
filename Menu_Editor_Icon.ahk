Menu_Editor_Icon(info){
	Gui,2:Default
	count:=menus.sn("//*[@filename]").length
	obj:=menu_editor("tvlist"),tvlist:=obj.tvlist,node:=tvlist[TV_GetSelection()],node.SetAttribute("filename",info.file),node.SetAttribute("icon",info.number)
	icons:=obj.icons,il:=obj.il
	if !(icons[info.file,info.number]){
		num:=icons[info.file,info.number]:=IL_Add(il,info.file,info.number)
		TV_Modify(TV_GetSelection(),"icon" num)
	}
	if !count
		node.SetAttribute("last",1),menu_editor(reload)
	WinActivate,% hwnd([2])
}