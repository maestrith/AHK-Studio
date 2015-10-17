testing(){
	;m("testing")
	return m(json)
	Gui,1:Color,Default,Default
	Gui,1:font
	for a,b in ["Edit1","Static1"]
		GuiControl,Font,%b%
	Loop,4
		GuiControl,Font,Button%A_Index%
	/*
		clone:=menus.xml.clonenode(1)
		rem:=clone.SelectSingleNode("//menu[@clean='Plugin']")
		rem.ParentNode.RemoveChild(rem)
		date:=clone.SelectSingleNode("//date")
		date.ParentNode.RemoveChild(date)
		SplitPath,A_ScriptFullPath,file,dir
		FileDelete,menus.xml
		FileAppend,% clone.xml,menus.xml
		;ftp:=x.get("ftp")
		f:=new ftp("files.maestrith.com")
		if f.Error
			return
		r:=f.put("menus.xml","AHK-Studio",0,1)
		if r
			x.m("Transfer complete")
	*/
	/*
		x:=ComObjActive("ahk-studio")
		x.call("github_repository",1)
		git:=new github()
		m(clipboard:=git.gettree())
	*/
	/*
		;clean out positions
		file:=positions.sn("//*/@file")
		while,ff:=file.Item[A_Index-1]
			if !FileExist(ff.text)
				ff.ParentNode.RemoveChild(ff)
	*/
}