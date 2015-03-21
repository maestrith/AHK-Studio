Gui(){
	#MaxHotkeysPerInterval,400
	Gui,+Resize +hwndhwnd -DPIScale
	OnMessage(5,"Resize"),hwnd(1,hwnd),ComObjError(0),v.startup:=1,OnMessage(6,"focus"),enter:=[]
	for a,b in ["+","!","^","~"]
		Enter[b "Enter"]:="checkqf"
	for a,b in StrSplit("WheelLeft,WheelRight",",")
		Enter[b]:="scrollwheel"
	Enter["^c"]:="copy",Enter["^x"]:="cut",hotkeys([1],enter)
	for a,b in ["esc & space","esc & ,"]
		Hotkey,%b%,eol,On
	Gui,Add,StatusBar,hwndsb,StatusBar Info
	new s(1,{main:1}),v.win2:=win2,v.win3:=win3
	ControlGetPos,,,,h,,ahk_id%sb%
	v.StatusBar:=h,v.sbhwnd:=sb,rb:=new rebar(1,hwnd),v.rb:=rb,pos:=settings.ssn("//gui/position[@window='1']")
	max:=ssn(pos,"@max").text?"Maximize":"",pos:=pos.text?pos.text:"w750 h500",bar:=[],band:=[]
	bar.10000:=[[4,"shell32.dll","Open","Open",10000,4],[8,"shell32.dll","Save","Save",10001,4],[137,"shell32.dll","Run","Run",10003,4],[249,"shell32.dll","Check_For_Update","Check For Update",10004,4],[100,"shell32.dll","New_Scintilla_Window","New Scintilla Window",10005,4],[271,"shell32.dll","Remove_Scintilla_Window","Remove Scintilla Window",10006,4]]
	bar.10001:=[[110,"shell32.dll","open_folder","Open Folder",10000,4],[135,"shell32.dll","google_search_selected","Google Search Selected",10001,4],[261,"shell32.dll","Menu_Editor","Menu Editor",10003,4]]
	bar.10002:=[[18,"shell32.dll","Connect","Connect",10000,4],[22,"shell32.dll","Debug_Current_Script","Debug Current Script",10001,4],[21,"shell32.dll","ListVars","List Variables",10002,4],[137,"shell32.dll","Run_Program","Run Program",10003,4],[27,"shell32.dll","stop","Stop",10004,4]]
	for id,info in bar
		for a,b in info{
		if !top:=settings.ssn("//toolbar/bar[@id='" id "']")
			top:=settings.add({path:"toolbar/bar",att:{id:id},dup:1})
		if !button:=ssn(top,"button[@id='" b.5 "']")
			button:=settings.under(top,"button"),vis:=1
		for a,c in {icon:b.1,file:b.2,func:b.3,text:b.4,id:b.5,state:b.6}
			button.SetAttribute(a,c)
		if vis
			button.SetAttribute("vis",1),vis:=0
		if !settings.ssn("//rebar/band[@id='" id "']")
			settings.add({path:"rebar/band",att:{id:id,vis:1},dup:1})
	}
	Gui,Add,Edit,w200 hwndedit
	ControlGetPos,,,,h,,ahk_id%edit%
	info:={hwnd:edit,ideal:220,id:11000,height:h,width:200,max:h}
	band.11000:={label:"Quick Find",hwnd:info.hwnd,height:info.height,ideal:info.ideal,id:11000,max:info.max,int:1,width:150}
	for a,b in band
		if !settings.ssn("//rebar/band[@id='" a "']")
			settings.add({path:"rebar/band",att:{id:a,width:150,vis:1},dup:1})
	toolbars:=settings.sn("//toolbar/bar"),bands:=settings.sn("//rebar/*[@vis='1']")
	while,bb:=toolbars.item[A_Index-1]{
		buttons:=sn(bb,"*"),tb:=new toolbar(1,hwnd,ssn(bb,"@id").text)
		while,button:=buttons.item[A_Index-1]
			ea:=settings.ea(button),tb.add(ea)
	}
	visible:=settings.sn("//toolbar/*/*[@vis='1']")
	while,vis:=Visible.item[A_Index-1]
		tb:=toolbar.list[ssn(vis.parentnode,"@id").text],tb.addbutton(ssn(vis,"@id").text)
	while,bb:=bands.item[A_Index-1]{
		if (bb.nodename="newline"){
			newline:=1
			continue
		}
		ea:=settings.ea(bb)
		if band[ea.id]
			ea:=band[ea.id]
		if !ea.width
			ea.width:=toolbar.list[ea.id].barinfo().ideal+20
		rb.add(ea,newline),newline:=0
	}
	Gui,1:Add,TreeView,gtv hwndtv
	Gui,1:Add,TreeView,AltSubmit gcej hwndtv2
	GuiControl,1:-Redraw,SysTreeView321
	TV_Add("Open files to have items populated here"),TV_Add("Right click to refresh")
	hwnd("fe",tv),hwnd("ce",tv2),refreshthemes(),debug.off(),list:=menus.sn("//main/descendant::*"),open:=settings.sn("//open/*")
	Gui,1:TreeView,% hwnd("fe")
	Gui,1:Menu,% Menu("main")
	all:=menus.sn("//*")
	while,aa:=all.item[A_Index-1]{
		parent:=ssn(aa.ParentNode,"@name").text,hotkey:=ssn(aa,"@hotkey").text,hotkey:=hotkey?"`t" convert_hotkey(hotkey):"",current:=ssn(aa,"@name").text
		Menu,%parent%,Delete,% current hotkey
	}
	Gui,1:Menu,% Menu("main")
	Gui,1:Show,%pos% %max%,AHK Studio
	while,oo:=open.item[A_Index-1]{
		if !FileExist(oo.text){
			rem:=settings.sn("//file[text()='" oo.text "']")
			while,rr:=rem.item[A_Index-1]
				rr.ParentNode.RemoveChild(rr)
		}else
			openfilelist.=oo.text "`n"
	}
	open(trim(openfilelist,"`n"),1)
	last:=settings.sn("//last/*")
	if !last.length
		new(1)
	Resize()
	WinSet,Redraw,,% hwnd([1])
	if v.tv
		tv(v.tv),setpos(v.tv)
	Else
		TV_Modify(files.ssn("//file[@file='" last.item[0].text "']/@tv").text)
	csc("Scintilla1"),bracesetup(),options(),traymenu(),v.startup:=0
	if (last.length>1){
		while,file:=last.item[A_Index-1]{
			if A_Index=1
				Continue
			New_Scintilla_Window(file.text)
		}
		csc({hwnd:s.main.1.sc}).2400
	}
	hk(1),Refresh_Variable_List()
	Gui,1:TreeView,SysTreeView321
	csc().4004("fold",[1]),new omni_search_class()
	SetTimer,scanfiles,0
}