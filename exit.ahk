Exit(x:="",reload:=0){
	GuiClose:
	rem:=settings.ssn("//last"),rem.ParentNode.RemoveChild(rem),notesxml.save(1),savegui()
	for a,b in s.main{
		file:=files.ssn("//*[@sc='" b.2357 "']/@file").text
		if file
			settings.add({path:"last/file",text:file,dup:1})
	}
	toolbar.save(),rebar.save(),menus.save(1),getpos()
	settings.add({path:"gui",att:{zoom:csc().2374}}),settings.save(1),bookmarks.save(1)
	for a in pluginclass.close
		If WinExist("ahk_id" a)
			WinClose,ahk_id%a%
	if(debug.socket){
		debug.send("stop")
		sleep,500
		debug.disconnect()
	}
	if(save(v.options.disable_autosave?1:0)="cancel")
		return
	if(reload){
		Reload
		ExitApp
	}
	if(x=""||InStr(A_ThisLabel,"Gui"))
		ExitApp
	return
}