menu_editor(x=0){
	static hwnd
	main:="main"
	if !x{
		Gui,2:destroy
		Gui,2:+hwndhwnd +Owner1
		setup(2)
		Gui,2:Add,Text,,Control+UP/DOWN/LEFT/RIGHT will move items
		hotkeys([2],{"Del":"deletenode"})
		Hotkey,^up,moveup,On
		Hotkey,^down,movedown,On
		Hotkey,^left,moveover,On
		Hotkey,^right,moveunder,On
		Gui,2:Add,TreeView,w500 h400 hwndhwnd
		Gui,2:Add,Button,gaddmenu,Add A New Menu
		Gui,2:Add,Button,x+10 gchangeitem,Change Item
		Gui,2:Add,Button,x+10 gaddsep,Add Separator
		Gui,2:Add,Button,x+10 gedithotkey Default,Edit Hotkey
		Gui,2:Add,Button,xm gmenudefault,Re-Load Defaults
		Gui,2:Add,Button,x+10 gsortmenus,Sort Menus Alphabetically
		Gui,2:Show,% Center(2),Menu Editor
	}
	Gui,1:Menu
	Gui,2:Default
	list:=menus.sn("//main/descendant::*")
	root:=0
	GuiControl,2:-Redraw,SysTreeView321
	del:=[],next:=0
	TV_Delete()
	while,ll:=list.item[A_Index-1]{
		hotkey:=ssn(ll,"@hotkey").text
		hot:=convert_hotkey(hotkey)
		hot:=hot?" - Hotkey = " hot:""
		hotkey:=hotkey?"`t" convert_hotkey(hotkey):""
		parent:=ssn(ll.ParentNode,"@tv").text?ssn(ll.ParentNode,"@tv").text:0
		root:=TV_Add(ssn(ll,"@name").text hot,parent)
		ll.SetAttribute("tv",root)
		deletelist.Insert(clean(ssn(ll,"@name").text))
		if ssn(ll,"@last").text
			count:=A_Index
	}
	while,ll:=list.item[A_Index-1]
		TV_Modify(ssn(ll,"@tv").text,"Expand")
	if !x{
		while,ll:=list.item[A_Index-1]{
			menu:=ssn(ll,"@name").text,parent:=ssn(ll.ParentNode,"@name").text
			parent:=parent?parent:main
			Menu,% clean(Parent),Delete,% ssn(ll,"@name").text
			Menu,% clean(parent),DeleteAll
		}
	}
	tv:=menus.ssn("//*[@last]")
	if tv
		TV_Modify(ssn(tv,"@tv").text,"Select"),tv.removeattribute("last")
	top:=count>10?count-10:0
	tv:=ssn(list.item[top],"@tv").text
	TV_Modify(tv,"VisFirst")
	GuiControl,2:+Redraw,SysTreeView321
	ControlFocus,SysTreeView321,% hwnd([2])
	return
	menudefault:
	SplashTextOn,,40,Downloading Required Files,Please Wait...
	menus.xml.save("lib\menusbackup " a_now ".xml")
	URLDownloadToFile,http://files.maestrith.com/alpha/Studio/menus.xml,lib\temp.xml
	FileRead,menu,lib\temp.xml
	menus.xml.loadxml(menu)
	menus.save(1)
	SplashTextOff
	menu_editor(1)
	return
	2GuiEscape:
	2GuiClose:
	hwnd({rem:2})
	list:=menus.sn("//main/descendant::*")
	while,rem:=list.item[A_Index-1]
		rem.removeattribute("tv")
	menus.save(1)
	all:=menus.sn("//*")
	main:="main"
	Gui,1:Menu
	while,aa:=all.item[A_Index-1]{
		menu:=ssn(aa,"@name").text,parent:=ssn(aa.ParentNode,"@name").text
		parent:=parent?parent:"main"
		Menu,% clean(Parent),Delete,% ssn(aa,"@name").text
	}
	Menu,main,Delete
	Gui,1:Menu,% menu("main")
	return
	addmenu:
	Gui,2:Default
	top:=menus.ssn("//*[@tv='" TV_GetSelection() "']")
	InputBox,newname,New Menu Item,Enter a new name (`&File for &File)
	if ErrorLevel
		return
	if (ssn(top,"@menu").text="")
		main:=top.ParentNode
	new:=menus.under({under:main,node:"menu",att:{name:newname,last:1}})
	main.insertbefore(new,top)
	under.insertbefore(above,move)
	menu_editor(1)
	return
	moveup:
	Gui,2:Default
	if prev:=TV_GetPrev(TV_GetSelection()){
		move:=menus.ssn("//*[@tv='" TV_GetSelection() "']")
		above:=menus.ssn("//*[@tv='" prev "']")
		move.SetAttribute("last",1)
		under:=move.parentnode
		under.insertbefore(move,above)
		menu_editor(1)
	}
	return
	movedown:
	Gui,2:Default
	if next:=TV_GetNext(TV_GetSelection()){
		move:=menus.ssn("//*[@tv='" TV_GetSelection() "']")
		above:=menus.ssn("//*[@tv='" next "']")
		move.SetAttribute("last",1)
		under:=move.parentnode
		under.insertbefore(above,move)
		menu_editor(1)
	}
	return
	deletenode:
	Gui,2:Default
	top:=menus.ssn("//*[@tv='" TV_GetSelection() "']")
	top.ParentNode.RemoveChild(top)
	TV_Delete(TV_GetSelection())
	return
	moveunder:
	Gui,2:Default
	top:=menus.ssn("//*[@tv='" TV_GetSelection() "']")
	if top.nextsibling.xml{
		under:=top.nextsibling.childnodes
		if under.length
			top.SetAttribute("last",1),top.nextsibling.insertbefore(top,under.item[0])
		else
			top.SetAttribute("last",1),top.nextsibling.appendchild(top)
		menu_editor(1)
	}
	return
	moveover:
	Gui,2:Default
	if !TV_GetParent(TV_GetSelection())
		return
	top:=menus.ssn("//*[@tv='" TV_GetSelection() "']")
	if (ssn(top.ParentNode,"@name").text!=""&&top.ParentNode.ParentNode.xml)
		before:=top.ParentNode,top.SetAttribute("last",1),top.ParentNode.ParentNode.insertbefore(top,before)
	menu_editor(1)
	return
	changeitem:
	Gui,2:Default
	current:=TV_GetSelection()
	item:=menus.ssn("//*[@tv='" current "']")
	item.setattribute("last",1)
	InputBox,newitem,Change Menu Name,Input a new name,,,,,,,,% ssn(item,"@name").text
	if ErrorLevel
		return
	menus.ssn("//*[@tv='" current "']/@name").text:=newitem
	menu_editor(1)
	return
	edithotkey:
	changehotkey()
	return
	98GuiEscape:
	hwnd({rem:98})
	WinActivate,% hwnd([2])
	mm:=menus.sn("//@hotkey/..")
	duplicate:=[],list:=[]
	while,dup:=mm.item[A_Index-1]{
		hotkey:=ssn(dup,"@hotkey").text
		if (hotkey="")
			Continue
		if list[hotkey]{
			if !IsObject(duplicate[hotkey])
				duplicate[hotkey]:=[]
			duplicate[hotkey]:=1
		}
		List[hotkey]:=1
	}
	for a,b in duplicate{
		list:=menus.sn("//*[@hotkey='" a "']")
		duplist.="Hotkey:`n"
		while,ll:=list.item[A_Index-1]
			duplist.=ssn(ll,"@name").text " = " ssn(ll,"@hotkey").text "`n"
		duplist.="`n"
	}
	if duplist
		MsgBox,48,Duplicates Found,Duplicate Hotkeys:`n`n%duplist%
	menu_editor(1)
	return
	addsep:
	Gui,2:Default
	top:=menus.ssn("//*[@tv='" TV_GetSelection() "']")
	main:=top.ParentNode
	new:=menus.under({under:main,node:"separator",att:{name:"-------",last:1}})
	main.insertbefore(new,top)
	menu_editor(1)
	return
	sortmenus:
	for a,b in StrSplit("File,Edit,Options,Quick_Find_Settings,Auto_Indent,Special_Menu,Help",","){
		root:=menus.ssn("//*[@clean='" b "']")
		list:=menus.sn("//*[@clean='" b "']/*"),order:=[]
		while,ll:=list.item[A_Index-1]
			order[ssn(ll,"@clean").text]:=ll
		for a,b in order
			root.appendchild(b)
	}
	menu_editor(1)
	return
}