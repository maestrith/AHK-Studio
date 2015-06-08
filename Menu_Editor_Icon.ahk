Menu_Editor_Icon(info){
	menu_Editor_Icon:
	Gui,2:Default
	count:=menus.sn("//*[@filename]").length,list:=menus.sn("//*[@last]"),obj:=menu_editor("tvlist"),tvlist:=obj.tvlist,node:=tvlist[TV_GetSelection()],node.SetAttribute("filename",info.file),node.SetAttribute("icon",info.number)
	if !count
		node.SetAttribute("last",1),menu_editor(2)
	else
		node.SetAttribute("last",1),menu_editor(2)
	WinActivate,% hwnd([2])
	return
}