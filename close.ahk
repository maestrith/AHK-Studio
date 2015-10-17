Close(node:=""){
	sc:=csc()
	save()
	Previous_Scripts(current(2).file)
	rem:=settings.ssn("//open/file[text()='" current(2).file "']")
	rem.ParentNode.RemoveChild(rem)
	Refresh_Project_Explorer()
	code_explorer.Refresh_Code_Explorer()
	PERefresh()
	new omni_search_class()
}