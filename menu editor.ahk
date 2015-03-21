menu_editor(x:=0){
	static hwnd,newwin,main:="main",TreeView,icons,il,tvlist
	if (x="tvlist")
		return {tvlist:tvlist,il:il,icons:icons}
	if !x{
		Gui,1:menu
		all:=menus.sn("//*")
		while,aa:=all.item[A_Index-1]{
			parent:=ssn(aa.ParentNode,"@name").text
			hotkey:=ssn(aa,"@hotkey").text,hotkey:=hotkey?"`t" convert_hotkey(hotkey):""
			current:=ssn(aa,"@name").text
			Menu,%parent%,Delete,% current hotkey
		}
		newwin:=new windowtracker(2),icons:=[]
		list:=menus.sn("//*[@icon!='']")
		if (list.length){
			il:=IL_Create(list.length)
			while,ii:=list.item[A_Index-1]{
				ea:=menus.ea(ii)
				if !icons[ea.filename,ea.icon]
					icons[ea.filename,ea.icon]:=IL_Add(il,ea.filename,ea.icon)
			}
			mil:="ImageList" il
		}
		newwin.Add(["Text,,Control+UP/DOWN/LEFT/RIGHT will move items","Edit,gmesearch w500,,w","ListView,w500 r9 gmego AltSubmit ReadOnly,Menu Item Search|Hotkey,w","TreeView,w500 r10 hwndhwnd " mil ",,wh","Button,gaddmenu,Add A New Menu,y","Button,x+10 gchangeitem,Change Item,y","Button,x+10 gaddsep,Add Separator,y","Button,x+10 gedithotkey Default,Edit Hotkey,y","Button,xm gmenudefault,Re-Load Defaults,y","Button,x+10 gsortmenus,Sort Menus,y","Button,x+10 gsortsubmenus,Sort Sub-Menus,y","Button,xm gmeci,Change Icon,y","Button,x+10 gmeri,Remove Icon,y","Button,x+10 gmerai,Remove All Icons From Current Menu,y"])
		hotkeys([2],{"Del":"deletenode","^up":"moveup","^down":"movedown","^left":"moveover","^right":"moveunder"})
		newwin.Show("Menu Editor")
		ControlGet,TreeView,hwnd,,SysTreeView321,% hwnd([2])
	}
	Gui,2:Default
	GuiControl,2:-Redraw,SysTreeView321
	list:=menus.sn("//main/descendant::*"),root:=0,del:=[],next:=0,lll:="",TV_Delete(),tvlist:=[]
	while,ll:=list.item[A_Index-1]{
		hotkey:=ssn(ll,"@hotkey").text,hot:=convert_hotkey(hotkey),hot:=hot?" - Hotkey = " hot:"",hotkey:=hotkey?"`t" convert_hotkey(hotkey):""
		parent:=ssn(ll.ParentNode,"@tv").text?ssn(ll.ParentNode,"@tv").text:0
		icon:=icons[ssn(ll,"@filename").text,ssn(ll,"@icon").text]?"icon" icons[ssn(ll,"@filename").text,ssn(ll,"@icon").text]:"icon-1"
		root:=TV_Add(RegExReplace(ssn(ll,"@clean").text,"_"," ") hot,parent,icon),lll.=RegExReplace(ssn(ll,"@clean").text,"_"," ") "|"
		tvlist[root]:=ll,ll.SetAttribute("tv",root),deletelist.Insert(clean(ssn(ll,"@name").text))
		if ssn(ll,"@last").text
			count:=A_Index
	}
	GuiControl,2:,ComboBox1,%lll%
	while,ll:=list.item[A_Index-1]
		TV_Modify(ssn(ll,"@tv").text,"Expand")
	ll:=[]
	top:=count>10?count-10:0
	tv:=ssn(list.item[top],"@tv").text
	TV_Modify(tv,"VisFirst")
	if x!=1
		ControlFocus,SysTreeView321,% hwnd([2])
	tv:=menus.ssn("//*[@last='1']")
	if tv{
		TV_Modify(ssn(tv,"@tv").text,"Select vis Focus"),tv.removeattribute("last")
		Sleep,100
	}
	else
		TV_Modify(TV_GetNext(0),"Select Vis Focus")
	last:=menus.sn("//*[@last=1]")
	while,ll:=last.item[A_Index-1]
		ll.removeattribute("last")
	GuiControl,2:+Redraw,SysTreeView321
	gosub,mesearch
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	LV_ModifyCol(2,"SortDesc")
	return
	mego:
	LV_GetText(edit,LV_GetNext())
	if tv:=menus.ssn("//*[@clean='" RegExReplace(edit," ","_") "']/@tv").text
		TV_Modify(tv,"Select Vis Focus")
	return
	merai:
	tv:=TV_GetParent(TV_GetSelection())?TV_GetParent(TV_GetSelection()):TV_GetSelection()
	node:=tvlist[tv]
	list:=sn(node,"*")
	while,ll:=list.item[A_Index-1]
		for a,b in ["filename","icon"]
			ll.removeattribute(b),TV_Modify(ssn(ll,"@tv").text,"Icon-1")
	return
	meri:
	node:=tvlist[TV_GetSelection()]
	node.removeattribute("filename"),node.removeattribute("icon"),TV_Modify(ssn(node,"@tv").text,"Icon-1")
	return
	meci:
	new icon_browser({action:"return",Func:"menu_editor_icon",caller:hwnd(2),close:1})
	return
	menudefault:
	clone:=menus.ssn("//main").clonenode(1)
	SplashTextOn,,40,Downloading Required Files,Please Wait...
	menus.xml.save("lib\menusbackup " a_now ".xml")
	URLDownloadToFile,http://files.maestrith.com/AHK-Studio/menus.xml,lib\temp.xml
	FileRead,menu,lib\temp.xml
	menus.xml.loadxml(menu),menus.save(1)
	oldlist:=sn(clone,"//*[@hotkey]")
	while,oo:=oldlist.item[A_Index-1]
		ea:=xml.ea(oo),item:=menus.ssn("//*[@clean='" ea.clean "']"),item.SetAttribute("hotkey",ea.hotkey)
	main:=menus.ssn("//main"),plug:=ssn(clone,"//menu[@clean='Plugin']")
	if plug.xml
		main.AppendChild(plug)
	SplashTextOff
	menu_editor(1)
	return
	2GuiEscape:
	2GuiClose:
	hwnd({rem:2}),list:=menus.sn("//main/descendant::*")
	while,rem:=list.item[A_Index-1]
		rem.removeattribute("tv")
	menus.save(1)
	Gui,1:Menu,% menu("main")
	for a,b in v.plugins
		Menu,Plugins,Add,%b%,menuhandler
	Menu,main,Add,Plugins,:Plugins
	WinSet,Redraw,,% hwnd([1])
	return
	mesearch:
	ControlGetText,edit,Edit1,% hwnd([2])
	ControlGetPos,x,y,w,h,Edit1,% hwnd([2])
	GuiControl,2:-Redraw,SysListView321
	LV_Delete(),ml:=cexml.sn("//menu/item")
	while,mm:=ml.Item[A_Index-1],b:=xml.ea(mm)
		if InStr(b.text,edit)
			LV_Add("",b.text,b.additional1)
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	GuiControl,2:+Redraw,SysListView321
	return
	addmenu:
	Gui,2:Default
	top:=menus.ssn("//*[@tv='" TV_GetSelection() "']")
	newname:=InputBox(TreeView,"New Menu Item","Enter a new name for a menu/item")
	if (ssn(top,"@menu").text="")
		main:=top.ParentNode
	new:=menus.under(main,"menu",{name:newname,last:1,clean:clean(newname)}),main.insertbefore(new,top),under.insertbefore(above,move),menu_editor(1)
	return
	moveup:
	Gui,2:Default
	if prev:=TV_GetPrev(TV_GetSelection()){
		move:=menus.ssn("//*[@tv='" TV_GetSelection() "']"),above:=menus.ssn("//*[@tv='" prev "']")
		move.SetAttribute("last",1),under:=move.parentnode,under.insertbefore(move,above),menu_editor(1)
	}
	return
	movedown:
	Gui,2:Default
	if next:=TV_GetNext(TV_GetSelection()){
		move:=menus.ssn("//*[@tv='" TV_GetSelection() "']"),above:=menus.ssn("//*[@tv='" next "']")
		move.SetAttribute("last",1),under:=move.parentnode,under.insertbefore(above,move),menu_editor(1)
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
	newitem:=InputBox(TreeView,"Change Menu Name","Input a new name",ssn(item,"@name").text)
	if ErrorLevel
		return
	menus.ssn("//*[@tv='" current "']/@name").text:=newitem
	menu_editor(1)
	return
	edithotkey:
	changehotkey()
	return
	addsep:
	Gui,2:Default
	top:=menus.ssn("//*[@tv='" TV_GetSelection() "']")
	main:=top.ParentNode
	new:=menus.under(main,"separator",{name:"-------",last:1})
	main.insertbefore(new,top)
	menu_editor(1)
	return
	sortmenus:
	for a,b in StrSplit("File,Edit,Options,Quick_Find_Settings,Auto_Indent,Tools,Special_Menu,Help",","){
		root:=menus.ssn("//*[@clean='" b "']")
		list:=menus.sn("//*[@clean='" b "']/*"),order:=[]
		while,ll:=list.item[A_Index-1]
			order[ssn(ll,"@clean").text]:=ll
		for a,b in order
			root.appendchild(b)
	}
	menu_editor(1)
	return
	sortsubmenus:
	all:=menus.sn("//main/descendant::*")
	while,root:=all.item[A_Index-1]{
		if (root.firstchild&&root.ParentNode.nodename!="main"){
			list:=sn(root,"*"),order:=[]
			while,ll:=list.item[A_Index-1]
				order[ssn(ll,"@clean").text]:=ll
			for a,b in order
				root.appendchild(b)
		}
	}
	menu_editor(1)
	return
}