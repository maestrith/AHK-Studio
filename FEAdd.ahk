FEAdd(value,parent,options){
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	if(v.options.hide_file_extensions){
		SplitPath,value,,,ext,name
		value:=ext="ahk"?name:value
	}
	return TV_Add(value,parent,options)
}