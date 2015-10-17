GetInclude(){
	GetInclude:
	main:=current(2).file,sc:=csc()
	SplitPath,main,,dir
	FileSelectFile,filename,,%dir%,Select a file to include,*.ahk
	if(ErrorLevel||filename="")
		return
	newfile:=filename~="\.ahk$"?filename:filename ".ahk"
	Relative:=RelativePath(ssn(current(),"@file").text,newfile)
	sc.2003(sc.2008," " Relative)
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	Refresh_Project_Explorer(newfile)
	return
}