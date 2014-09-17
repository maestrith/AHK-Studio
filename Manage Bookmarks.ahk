Manage_Bookmarks(){
	static wname:="Manage_Bookmarks",tv:=[],newwin
	newwin:=new windowtracker(wname)
	newwin.Add(["TreeView,w450 h400 vtv gmbsel AltSubmit,,wh","Button,xm gesb Default,Change Selected Bookmarks Name,y","Button,gdab,Delete All Bookmarks From All Files,y","Button,x+10 gdsb,Delete Selected Bookmark,y"])
	newwin.Show(RegExReplace(wname,"_"," "))
	Goto popbookmarks
	return
	esb:
	Gui,Manage_Bookmarks:Default
	tvn:=tv[TV_GetSelection()],ea:=bookmarks.ea(tvn)
	if !ea.name
		return m("Please Select A Bookmark")
	name:=InputBox(newwin.tv,"New Segment","Enter a name for this new name",ea.name)
	if !bookmarks.ssn("//*[@name='" name "']"){
		TV_Modify(TV_GetSelection(),"",name)
		tvn.SetAttribute("name",name)
	}
	return
	popbookmarks:
	all:=bookmarks.sn("//bookmarks/main")
	while,aa:=all.item[A_Index-1]
		if !ssn(aa,"descendant::mark")
			aa.ParentNode.RemoveChild(aa)
	Gui,manage_bookmarks:Default
	all:=bookmarks.sn("//bookmarks/descendant::*"),tv:=[],TV_Delete()
	while,aa:=all.item[A_Index-1]{
		if (aa.NodeName="main")
			top:=TV_Add(ssn(aa,"@file").text)
		if (aa.NodeName="file")
			file:=TV_Add(ssn(aa,"@file").text,top)
		if (aa.NodeName="mark")
			tv[TV_Add(ssn(aa,"@name").text,file,"Vis")]:=aa
	}
	return
	dsb:
	tvn:=tv[TV_GetSelection()],line:=ssn(tvn,"@line").text
	if !line
		return
	csc().2044(line,4),tvn.ParentNode.RemoveChild(tvn)
	goto popbookmarks
	return
	mbsel:
	if (A_GuiEvent~="i)(S|Normal)"){
		tvn:=tv[A_EventInfo],sc:=csc(),sc.2045(3)
		if !line:=ssn(tvn,"@line").text
			return
		tv(files.ssn("//main[@file='" ssn(tvn.ParentNode.ParentNode,"@file").text "']/file[@file='" (ssn(tvn.ParentNode,"@file").text) "']/@tv").text)
		Sleep,300
		sc.2024(line),sc.2045(3),sc.2043(line,3)
		ControlFocus,,% "ahk_id" sc.sc
	}
	return
	dab:
	MsgBox,52,Are you sure?,Can not be undone!
	IfMsgBox,Yes
	{
		lines:=bookmarks.sn("//mark"),sc:=csc()
		while,ll:=lines.item[A_Index-1]{
			tv(files.ssn("//main[@file='" ssn(ll.ParentNode.ParentNode,"@file").text "']/file[@file='" (ssn(ll.ParentNode,"@file").text) "']/@tv").text)
			Sleep,300
			sc.2045(4)
			ll.ParentNode.RemoveChild(ll)
		}
		goto popbookmarks
	}
	return
	Manage_BookmarksGuiEscape:
	Manage_BookmarksGuiClose:
	csc().2045(3)
	hwnd({rem:wname})
	return
}