gui(){
	Gui,+Resize +hwndhwnd
	OnMessage(5,"Resize"),hwnd(1,hwnd),ComObjError(0),v.startup:=1
	Hotkey,IfWinActive,% hwnd([1])
	Hotkey,~Enter,checkqf,On
	for a,b in ["+","!","^"]
		Hotkey,%b%Enter,checkqf,On
	hk(1)
	SysGet,Border,33
	SysGet,Caption,4
	v.border:=border,v.caption:=caption
	new s(1,{main:1}),v.win2:=win2,v.win3:=win3
	Gui,Add,StatusBar,hwndsb,StatusBar Info
	SB_SetParts(400,400)
	ControlGetPos,,,,h,,ahk_id%sb%
	v.StatusBar:=h,v.sbhwnd:=sb
	DetectHiddenWindows,On
	rb:=new rebar(1,hwnd),v.rb:=rb,pos:=settings.ssn("//gui/position[@window='1']")
	max:=ssn(pos,"@max").text?"Maximize":"",pos:=pos.text?pos.text:"w750 h500",bar:=[],band:=[]
	bar.10000:=[[4,"shell32.dll","Open","Open",10000,4],[8,"shell32.dll","Save","Save",10001,4],[137,"shell32.dll","Run","Run",10003,4],[249,"shell32.dll","Check_For_Update","Check For Update",10004,4],[100,"shell32.dll","New_Scintilla_Window","New Scintilla Window",10005,4],[271,"shell32.dll","Remove_Scintilla_Window","Remove Scintilla Window",10006,4]]
	bar.10001:=[[110,"shell32.dll","open_folder","Open Folder",10000,4],[135,"shell32.dll","google_search_selected","Google Search Selected",10001,4],[261,"shell32.dll","Menu_Editor","Menu Editor",10003,4]]
	bar.10002:=[[18,"shell32.dll","Connect","Connect",10000,4],[22,"shell32.dll","Debug_Current_Script","Debug Current Script",10001,4],[21,"shell32.dll","ListVars","List Variables",10002,4],[137,"shell32.dll","Run_Program","Run Program",10003,4],[27,"shell32.dll","stop","Stop",10004,4]]
	if bardef:=settings.ssn("//toolbar/default"){ ;backward compatibility
		barvis:=settings.ssn("//toolbar/visible"),lbd:=sn(bardef,"*"),top:=settings.ssn("//toolbar")
		while,ll:=lbd.item[A_Index-1]{
			top.appendchild(ll),lll:=sn(ll,"*")
			while,llll:=lll.item[A_Index-1]{
				vis:=ssn(barvis,"bar[@id='" ssn(ll,"@id").text "']/button[@id='" ssn(llll,"@id").text "']").xml?1:0
				llll.setattribute("vis",vis)
			}
		}
		for a,b in [bardef,barvis]
			b.parentnode.removechild(b)
	}
	if bandvis:=settings.ssn("//rebar/visible"){
		banddef:=settings.ssn("//rebar/default/bands"),lbd:=sn(bandvis,"*"),top:=settings.add({path:"rebar"})
		while,ll:=lbd.item[A_Index-1]
			ll.setattribute("vis",1),top.appendchild(ll)
		for a,b in [banddef.parentnode,bandvis]
			b.parentnode.removechild(b)
	} ;/backward compatibility
	for id,info in bar
	for a,b in info{
		if !top:=settings.ssn("//toolbar/bar[@id='" id "']")
			top:=settings.add({path:"toolbar/bar",att:{id:id},dup:1})
		if !button:=ssn(top,"button[@id='" b.5 "']")
			button:=settings.under({under:top,node:"button"}),vis:=1
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
	toolbars:=settings.sn("//toolbar/bar")
	while,bb:=toolbars.item[A_Index-1]{
		buttons:=sn(bb,"*"),tb:=new toolbar(1,hwnd,ssn(bb,"@id").text)
		while,button:=buttons.item[A_Index-1]
			ea:=settings.ea(button),tb.add(ea)
	}
	visible:=settings.sn("//toolbar/*/*[@vis='1']")
	while,vis:=Visible.item[A_Index-1]
		tb:=toolbar.list[ssn(vis.parentnode,"@id").text],tb.addbutton(ssn(vis,"@id").text)
	bands:=settings.sn("//rebar/*[@vis='1']")
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
	msg:=["What do you think?`r`nRight Click a `r`nToolbar to customize it`r`nControl+Click a toolbar icon to change the icon","I like it"]
	for a,b in s.main
		b.2242(0,20),b.2242(1,0),b.2181(0,msg[A_Index])
	open:=settings.sn("//open/*")
	Gui,1:Add,TreeView,Background0 c0xAAAAAA gtv hwndtv
	Gui,1:Add,TreeView,Background0 c0xAAAAAA AltSubmit gcej hwndtv2
	TV_Add("Open files to have items populated here"),TV_Add("Right click to refresh")
	hwnd("fe",tv),hwnd("ce",tv2),refreshthemes(),debug.off(),list:=menus.sn("//main/descendant::*")
	Gui,1:TreeView,% hwnd("fe")
	Gui,1:Menu,% Menu("main")
	Gui,1:Menu
	while,ll:=list.item[A_Index-1]{
		menu:=ssn(ll,"@name").text,parent:=ssn(ll.ParentNode,"@name").text,parent:=parent?parent:main
		Menu,% clean(parent),DeleteAll
	}
	Gui,1:Menu,% Menu("main")
	Gui,1:Show,%pos% %max%,AHK Studio
	while,oo:=open.item[A_Index-1]{
		if FileExist(oo.text)
			open(oo.text),last:=oo.text
		else{
			rem:=settings.sn("//file[text()='" oo.text "']")
			while,rr:=rem.item[A_Index-1]
				rr.ParentNode.RemoveChild(rr)
		}
	}
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
	SplashTextOn,200,50,Indexing Files,Please Wait...
	code_explorer.populate()
	SplashTextOff
	Gui,1:TreeView,SysTreeView321
}
hk(win){
	hotkeys([win],{"+left":"+left","+right":"+right",left:"left",right:"right","+^LButton":"addsel"
	,"^v":"paste","~Escape":"multisel","~Tab":"deadend","^A":"SelectAll"})
	hk:=menus.sn("//*[@hotkey!='']|//*[@clean!='omni_search']")
	while,(ea:=xml.ea(hk.item[A_Index-1])).clean{
		if !ea.Hotkey
			Continue
		if (win!=1){
			if RegExMatch(ea.clean,"i)\b(Run|Run_As_Ansii|Run_As_U32|Run_As_U64|Debug_Current_Script)\b")
				Continue
		}
		list:=[],List[ea.hotkey]:=ea.clean,hotkeys([win],list)
	}
}