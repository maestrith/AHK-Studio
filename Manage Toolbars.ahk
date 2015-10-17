Manage_Toolbars(){
	newwin:=new WindowTracker(34),newwin.add(["ListView,w250 h200 gmtshow AltSubmit Checked,Show,w","Button,w250 gmtat,Add Toolbar,w","Button,w250 gmtdel,Delete/Hide Toolbar,w","ListView,w250 r10,Menu Items,wh","Button,w250 gmtmenu,Add Selected Command,yw","Button,w250 gmtrun,Run External File...,yw"])
	menu:=menus.sn("//*")
	while,mm:=menu.item[A_Index-1]{
		mname:=clean(ssn(mm,"@name").text)
		if (mname&&InStr(mname,"---")=0&&(IsFunc(mname)||IsLabel(mname)))
			LV_Add("",mname)
	}
	gosub,mtpop
	newwin.show("Manage Toolbars"),LV_Modify(1,"Select Vis Focus")
	return
	mtrun:
	mtmenu:
	Gui,34:Default
	Gui,34:ListView,SysListView321
	if(!LV_GetNext())
		return m("Please select a toolbar in the list above")
	LV_GetText(barid,LV_GetNext())
	if(barid=10002)
		return m("Sorry, but you can not add to this toolbar")
	Gui,34:Default
	Gui,34:ListView,SysListView322
	newid:=11099,bar:=toolbar.list[barid]
	while,settings.ssn("//toolbar/bar[@id='" barid "']/button[@id='" ++newid "']"){
	}
	under:=settings.ssn("//toolbar/bar[@id='" barid "']")
	if (A_ThisLabel="mtrun"){
		FileSelectFile,filename
		if ErrorLevel
			return
		SplitPath,filename,,,,nne
		iconfile:=InStr(filename,".ahk")?A_AhkPath:filename,att:={vis:1,icon:0,file:iconfile,text:nne,func:"runfile",id:newid,state:4,runfile:filename},bar.add(att),bar.addbutton(newid),settings.under(under,"button",att)
	}else
		LV_GetText(item,LV_GetNext()),text:=RegExReplace(item,"_"," "),att:={vis:1,icon:1,file:"shell32.dll",text:text,func:item,id:newid,state:4},bar.add(att),bar.addbutton(newid),settings.under(under,"button",att)
	new icon_browser({focus:hwnd([34]),close:1,ofile:"shell32.dll",oicon:1,id:att.id,ahkid:toolbar.list[barid].ahkid,tb:toolbar.list[barid],Func:"Manage_Toolbars",caller:hwnd(hwnd),close:1,desc:att.text})
	return
	mtpop:
	Gui,34:Default
	Gui,34:ListView,SysListView321
	rb:=settings.sn("//rebar/descendant::*"),LV_Delete()
	while,rr:=rb.item[A_Index-1],rea:=xml.ea(rr)
		if(tb:=settings.ssn("//toolbar/bar[@id='" rea.id "']"))
			LV_Add(_:=rea.vis?"Check":"",rea.id)
	return
	mtdel:
	Gui,34:Default
	Gui,34:ListView,SysListView321
	if(!LV_GetNext())
		return
	LV_GetText(id,next:=LV_GetNext())
	if(id>=10000&&id<=10002){
		settings.ssn("//rebar/band[@id='" id "']").SetAttribute("vis",0)
		return rebar.hw.1.hide(id),LV_Modify(next,"-Check")
	}
	MsgBox,52,Are you sure?,This will completely delete this toolbar`nThis can not be undone!`nAre you sure?
	IfMsgBox,No
		return
	rebar.hw.1.hide(id)
	for a,b in [settings.ssn("//rebar/band[@id='" id "']"),settings.ssn("//toolbar/bar[@id='" id "']")]
		if b.xml
			b.ParentNode.RemoveChild(b)
	rebar.hw.1.delete(id),LV_Delete(next),LV_Modify(next-1,"Select Vis Focus")
	return
	mtat:
	Add_Toolbar()
	goto,mtpop
	return
	mtshow:
	Gui,34:Default
	Gui,34:ListView,SysListView321
	if(ErrorLevel="c"){
		Loop,% LV_GetCount()
			LV_GetText(id,A_Index),check:=LV_GetNext(A_Index-1,"C")=A_Index?"Show":"Hide",temp:=rebar.hw.1,value:=settings.ssn("//rebar/band[@id='" id "']"),value.SetAttribute("vis",check="show"?1:0),temp[check](id)
	}
	return
	34GuiEscape:
	34GuiClose:
	hwnd({rem:34})
	return
}