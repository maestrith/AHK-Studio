exit(x="",reload=0){
	GuiClose:
	rem:=settings.ssn("//last"),rem.ParentNode.RemoveChild(rem)
	for a,b in s.main{
		file:=files.ssn("//*[@sc='" b.2357 "']/@file").text
		if file
			settings.add({path:"last/file",text:file,dup:1})
	}
	toolbar.save(),rebar.save(),save(v.options.disable_autosave?1:0),menus.save(1),getpos()
	settings.add({path:"gui",att:{zoom:csc().2374}}),settings.save(1),bookmarks.save(1)
	if (reload){
		Reload
		ExitApp
	}
	if (x=""||InStr(A_ThisLabel,"Gui"))
		ExitApp
	return
	GuiEscape:
	ControlGetFocus,Focus,% hwnd([1])
	csc().2400
	return
}