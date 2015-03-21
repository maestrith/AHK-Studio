close(){
	sc:=csc(),save(),code_explorer.remove(current(1)),previous_scripts(ssn(current(1),"@file").text)
	Gui,1:TreeView,SysTreeView321
	main:=current(1),rem:=cexml.ssn("//main[@file='" xml.ea(main).file "']"),rem.ParentNode.RemoveChild(rem)
	rem:=settings.sn("//file[text()='" ssn(main,"@file").text "']"),Remove:=cexml.ssn("//main[@file='" current(2).file "']"),Remove.ParentNode.RemoveChild(Remove)
	while,rr:=rem.item[A_Index-1]
		rr.ParentNode.RemoveChild(rr)
	udf:=update("get").1,close:=sn(main,"*")
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	while,cc:=close.item[A_Index-1]{
		ea:=xml.ea(cc)
		if ea.tv
			TV_Delete(ea.tv)
		if files.sn("//*[@sc='" ea.sc "']").length=1
			sc.2377(0,ea.sc)
		udf.Remove(ea.file)
	}
	main.ParentNode.RemoveChild(main)
	if files.sn("//*").length=1
		new(1)
	code_explorer.Refresh_Code_Explorer()
}