addbutton(this){
	static bar
	v.bar:=bar:=this,ComObjError(1),setup(12)
	Gui,Add,ListView,w400 h300,Menu Items
	menu:=menus.sn("//*")
	while,mm:=menu.item[A_Index-1]{
		mname:=clean(ssn(mm,"@name").text)
		if (mname&&InStr(mname,"---")=0&&(IsFunc(mname)||IsLabel(mname)))
			LV_Add("",mname)
	}
	Gui,Add,Button,gabrun,Add A Launch Button
	Gui,Add,Button,gabmenu,Add A Menu Button
	Gui,Show,,Add Buttons
	return
	abrun:
	abmenu:
	newid:=11099
	while,settings.ssn("//toolbar/bar[@id='" bar.id "']/button[@id='" ++newid "']"){
	}
	under:=settings.ssn("//toolbar/bar[@id='" bar.id "']")
	if (A_ThisLabel="abrun"){
		FileSelectFile,filename
		if ErrorLevel
			return
		SplitPath,filename,,,,nne
		iconfile:=InStr(filename,".ahk")?A_AhkPath:filename
		att:={icon:0,file:iconfile,text:nne,func:"runfile",id:newid,state:4,runfile:filename}
		bar.add(att),bar.addbutton(newid),settings.under({under:under,node:"button",att:att})
	}else{
		LV_GetText(item,LV_GetNext())
		text:=RegExReplace(item,"_"," ")
		att:={icon:1,file:"shell32.dll",text:text,func:item,id:newid,state:4},bar.add(att)
		bar.addbutton(newid),settings.under({under:under,node:"button",att:att})
	}
	return
	12GuiClose:
	12GuiEscape:
	hwnd({rem:12})
	return
}