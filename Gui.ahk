Gui(){
	#MaxHotkeysPerInterval,400
	Gui,+Resize +hwndhwnd -DPIScale
	Gui,Margin,0,0
	OnMessage(5,"Resize"),OnMessage(0x232,"Redraw"),hwnd(1,hwnd),ComObjError(0),v.startup:=1,OnMessage(6,"focus"),enter:=[]
	for a,b in ["+","!","^","~"]
		Enter[b "Enter"]:="checkqf",Enter[b "NumpadEnter"]:="checkqf"
	for a,b in StrSplit("WheelLeft,WheelRight",",")
		Enter[b]:="scrollwheel"
	for a,b in {"NumpadEnter":"checkqf","~Delete":"Delete","~Backspace":"Backspace","^Backspace":"Backspace","^c":"copy","^x":"cut","~^v":"paste"}
		Enter[a]:=b
	Enter["~RButton"]:="RButton"
	hotkeys([1],enter)
	Gui,Add,StatusBar,hwndsb,StatusBar Info
	new s(1,{main:1}),v.win2:=win2,v.win3:=win3
	ControlGetPos,,,,h,,ahk_id%sb%
	v.Status:=h,v.sbhwnd:=sb,rb:=new rebar(1,hwnd),v.rb:=rb,pos:=settings.ssn("//gui/position[@window='1']")
	max:=ssn(pos,"@max").text?"Maximize":"",pos:=pos.text?pos.text:"w750 h500"
	bar:=[],band:=[]
	bar.10000:=[[4,"shell32.dll","Open","Open",10000,4],[8,"shell32.dll","Save","Save",10001,4],[137,"shell32.dll","Run","Run",10003,4],[249,"shell32.dll","Check_For_Update","Check For Update",10004,4],[100,"shell32.dll","New_Scintilla_Window","New Scintilla Window",10005,4],[271,"shell32.dll","Remove_Scintilla_Window","Remove Scintilla Window",10006,4]]
	bar.10001:=[[110,"shell32.dll","open_folder","Open Folder",10000,4],[135,"shell32.dll","google_search_selected","Google Search Selected",10001,4],[261,"shell32.dll","Menu_Editor","Menu Editor",10003,4]]
	bar.10002:=[[18,"shell32.dll","Connect","Connect",10000,4],[22,"shell32.dll","Debug_Current_Script","Debug Current Script",10001,4],[21,"shell32.dll","ListVars","List Variables",10002,4],[137,"shell32.dll","Run_Program","Run Program",10003,4],[27,"shell32.dll","stop","Stop",10004,4]]
	if(!toolbarobj:=settings.ssn("//toolbar")){
		temp:=new xml("temp"),top:=temp.ssn("//*"),tbo:=temp.under(top,"toolbar")
		for a,b in bar{
			btop:=temp.under(tbo,"bar",{id:a})
			for c,d in b{
				att:=[]
				for e,f in ["icon","file","func","text","id","state"]
					att[f]:=d[A_Index]
				att["vis"]:=1
				temp.under(btop,"button",att)
			}
		}
		temp.transform(),top:=temp.ssn("//toolbar"),main:=settings.ssn("//*"),main.AppendChild(top)
		toolbarobj:=settings.ssn("//toolbar")
	}
	if(rem:=settings.ssn("//rebar/band[@id='11000']"))
		rem.ParentNode.RemoveChild(rem)
	;redo this
	Gui,Add,Text,xm+3 c0xAAAAAA,Quick Find
	Gui,Add,Edit,x+2 w200 c0xAAAAAA gqf
	ea:=settings.ea("//Quick_Find_Settings"),v.options:=[]
	for a,b in ["Regex","Case Sensitive","Greed","Multi Line"]{
		checked:=ea[clean(b)]?"Checked":"",v.options[clean(b)]:=ea[clean(b)]
		Gui,Add,Checkbox,x+3 c0xAAAAAA gqfs %Checked%,%b%
	}
	ControlGetPos,,,,h,,ahk_id%edit%
	band.10000:={id:10000,vis:1,width:263},band.10001:={id:10001,vis:1,width:150},band.10002:={id:10002,vis:1,width:200} ;,band.11000:={label:"Quick Find",hwnd:edit,height:h,ideal:220,id:11000,max:h,int:1,width:150}
	if(!settings.ssn("//rebar"))
		for a,b in band
			if !settings.ssn("//rebar/band[@id='" a "']")
				settings.add({path:"rebar/band",att:{id:a,width:b.width,vis:1},dup:1})
	toolbars:=settings.sn("//toolbar/bar"),bands:=settings.sn("//rebar/descendant::*")
	while,bb:=toolbars.item[A_Index-1]{
		buttons:=sn(bb,"*"),tb:=new toolbar(1,hwnd,ssn(bb,"@id").text)
		while,button:=buttons.item[A_Index-1]
			tb.add(xml.ea(button))
	}
	visible:=settings.sn("//toolbar/*/*[@vis='1']")
	while,vis:=Visible.item[A_Index-1]
		tb:=toolbar.list[ssn(vis.parentnode,"@id").text],tb.addbutton(ssn(vis,"@id").text)
	while,bb:=bands.item[A_Index-1],ea:=xml.ea(bb){
		if(bb.nodename="newline"){
			newline:=1
			continue
		}
		if(ea.id=11000)
			ea:=band[ea.id]
		if(!ea.width)
			ea.width:=toolbar.list[ea.id].barinfo().ideal+20
		rb.add(ea,newline),newline:=0
	}
	hide:=settings.sn("//rebar/descendant::*[@vis='0']")
	while,hh:=hide.item[A_Index-1],ea:=xml.ea(hh)
		rb.hide(ea.id)
	;/redo this
	Gui,1:Add,TreeView,xm gtv hwndtv
	TVIcons()
	Gui,1:Add,TreeView,AltSubmit gcej hwndtv2
	GuiControl,1:-Redraw,SysTreeView321
	TV_Add("Open files to have items populated here"),TV_Add("Right click to refresh"),hwnd("fe",tv),hwnd("ce",tv2),refreshthemes(),debug.off(),list:=menus.sn("//main/d`endant::*"),open:=settings.sn("//open/*")
	Gui,1:TreeView,% hwnd("fe")
	Gui,1:Menu,% Menu("main")
	while,oo:=open.item[A_Index-1]{
		if !FileExist(oo.text){
			rem:=settings.sn("//file[text()='" oo.text "']")
			while,rr:=rem.item[A_Index-1]
				rr.ParentNode.RemoveChild(rr)
		}else
			openfilelist.=oo.text "`n"
	}
	if(openfilelist)
		open(trim(openfilelist,"`n"))
	last:=settings.sn("//last/*")
	Gui,1:Color,Default,Default
	Gui,1:font
	for a,b in ["Edit1","Static1"]
		GuiControl,Font,%b%
	Loop,4
		GuiControl,Font,Button%A_Index%
	Gui,1:Show,%pos% %max%,AHK Studio
	WinSetTitle,% hwnd([1]),,AHK Studio - Indexing Library Files
	Index_Lib_Files(),Resize("rebar")
	if !last.length
		new(1)
	Resize("rebar"),Margin_Left(1)
	WinSet,Redraw,,% hwnd([1])
	tv(files.ssn("//file[@file='" last.item[0].text "']/@tv").text,1)
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
	csc().4004("fold",[1]),new omni_search_class(),SetMatch()
	GuiControl,+Redraw,% csc().sc
	/*
		if(settings.ssn("//notes/@open").text){
			Notes(1)
			WinActivate,% hwnd([1])
		}
	*/
	SetTimer,scanfiles,0
}