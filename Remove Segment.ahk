Remove_Segment(){
	current:=current(),mainnode:=current(1),curfile:=current(3).file
	while,!filename:=ssn(current.ParentNode,"@file").text
		current:=current.ParentNode
	tv:=ssn(current.ParentNode,"@tv").text
	include:=ssn(current(),"@include").text
	remfile:=current(3).file
	if (current(3).file=filename)
		return m("You can not remove the main file from the project")
	MsgBox,260,Remove Segment from this Project?,Remove it?
	IfMsgBox,No
		return
	MsgBox,308,Delete this file from the computer?,Permanently delete this file?
	IfMsgBox,Yes
		FileDelete,% ssn(current(),"@file").text
	mainfile:=update({get:filename})
	StringReplace,mainfile,mainfile,%include%,,All
	current.ParentNode.RemoveAttribute("sc"),update({file:filename,text:mainfile}),update({edited:filename})
	Gui,1:TreeView,SysTreeView321
	TV_Delete(xml.ea(current).tv),parent:=current().ParentNode,current.ParentNode.RemoveChild(current)
	Sleep,100
	tv(ssn(mainnode.firstchild,"@tv").text)
	rem:=cexml.ssn("//main[@file='" current(2).file "']descendant::file[@file='" curfile "']")
	rem.ParentNode.RemoveChild(rem)
}