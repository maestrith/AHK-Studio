Remove_Segment(){
	current:=current()
	filename:=ssn(current(1),"@file").Text
	include:=ssn(current(),"@include").text
	if (ssn(current,"@file").text=filename)
		return m("You can not remove the main file from the project")
	MsgBox,260,Remove Segment from this Project?,Remove it?
	IfMsgBox,No
		return
	MsgBox,308,Delete this file from the computer?,Permanently delete this file?
	IfMsgBox,Yes
		FileDelete,% ssn(current,"@file").text
	v.filelist.remove(ssn(current,"@file").text)
	mainfile:=update({get:filename})
	StringReplace,mainfile,mainfile,%include%,,All
	update({file:filename,text:mainfile})
	scin:=ssn(current(1),"file").removeattribute("sc") ;,scin.ParentNode.removechild(scin)
	TV(ssn(current(1),"@tv").text)
	Gui,1:TreeView,SysTreeView32
	TV_Delete(ssn(current,"@tv").text)
	tv(ssn(current.previousSibling,"@tv").text)
	current.parentnode.removechild(current)
	up:=update({edited:filename})
}