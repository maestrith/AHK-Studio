Refresh_Project_Explorer(openfile:=""){
	static parent,file
	Gui,1:Default
	GuiControl,1:-Redraw,SysTreeView321
	parent:=current(2).file,file:=current(3).file,Save(),files:=new xml("files"),open:=settings.sn("//open/*"),cexml:=new xml("code_explorer")
	while,oo:=open.item[A_Index-1]{
		if !FileExist(oo.text){
			rem:=settings.sn("//file[text()='" oo.text "']")
			while,rr:=rem.item[A_Index-1]
				rr.ParentNode.RemoveChild(rr)
		}else
			openfilelist.=oo.text "`n"
	}
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	TV_Delete(),Open(Trim(openfilelist,"`n"))
	for a,b in [openfile,file]
		if(tv:=files.ssn("//main[@file='" parent "']/descendant::file[@file='" b "']/@tv").text)
			break
	tv(tv?tv:TV_GetChild(0),1),Index_Lib_Files()
}