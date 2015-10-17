Refresh_Project_Treeview(select:="",parent:=""){
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	all:=files.sn("//files/descendant::*")
	TV_Delete()
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
		if(aa.nodename="main")
			Continue
		aa.SetAttribute("tv",TV_Add(aa.nodename="folder"?ea.name:ea.filename,ssn(aa.ParentNode,"@tv").text,aa.nodename="folder"?"icon1":"icon2"))
	}
	if(select)
		tv(files.ssn("//main[@file='" parent "']/descendant::file[@file='" select "']/@tv").text)
}