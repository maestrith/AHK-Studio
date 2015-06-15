testing(){
	x:=ComObjActive("ahk-studio")
	x.call("github_repository",1)
	/*
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