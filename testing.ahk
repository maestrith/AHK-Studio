testing(){
	files.Transform()
	Gui,1:TreeView,SysTreeView321
	m("Files entry" files.ssn("//*[@tv='" TV_GetSelection() "']").xml)
	m(current(3).file)
	;tt:=update({get:current(3).file})
	m(current(1).xml,"","",tt)
}