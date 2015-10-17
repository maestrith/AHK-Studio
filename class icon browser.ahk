class icon_browser{
	static start:="",window:=[],keep:=[],newwin,caller
	__New(info){
		static click
		win:=85,this.refreshwindow(),newwin:=new windowtracker(win),newwin.Add(["Text,,Editing icon for: " info.desc,"ListView,w500 h300 hwndlv gselect vselect AltSubmit Icon -Multi,Small,wh","Button,xm gloadfile,Load File (Icon/DLL/Image),y","Button,x+10 gloaddefault,Load Default Icons,y","Button,x+10 gibc,Cancel,y"]),newwin.Show("Icon Browser"),this.file:=(ic:=settings.ssn("//icons/@last").text)?ic:"shell32.dll",this.file:=InStr(this.file,".ahk")?A_AhkPath:this.file,this.create(),icon_browser.caller:=info.caller,LV_SetImageList(this.il),this.close:=info.close,this.win:=win,icon_browser.keep:=this,this.newwin:=newwin,this.spacing()
		for a,b in info
			this[a]:=b
		return
		85GuiEscape:
		85GuiClose:
		hwnd({rem:85})
		if icon_browser.caller
			WinActivate,% "ahk_id" icon_browser.caller
		return
		ibc:
		this:=icon_browser.keep,number:=this.oicon+1,NumPut(VarSetCapacity(button,32),button,0),NumPut(0x1|0x20,button,4),NumPut(this.id,button,8),num:=this.tb.iconlist[this.ofile,number]!=""?this.tb.iconlist[this.ofile,number]:IL_Add(this.tb.imagelist,this.ofile,number)-1,this.tb.iconlist[this.ofile,number]:=num,NumPut(num,button,12)
		SendMessage,0x400+64,% this.id,&button,,% this.ahkid
		btn:=settings.ssn("//toolbar/bar[@id='" this.tb.id "']/button[@id='" this.id "']"),btn.setattribute("icon",number-1),btn.setattribute("file",this.ofile),hwnd({rem:85})
		return
		loaddefault:
		this:=icon_browser.keep,this.file:="shell32.dll",this.start:=0,this.next(),settings.add2("icons").SetAttribute("last","Shell32.dll")
		return
	}
	spacing(){
		ea:=settings.ea("//icons"),LV_Delete()
		GuiControl,85:-Redraw,SysListView321
		while,icon:=IL_Add(this.il,this.file,A_Index)
			LV_Add("Icon" icon)
		SendMessage,0x1000+53,0,(47<<16)|(47&0xffff),,% "ahk_id" this.newwin.select
		GuiControl,85:+Redraw,SysListView321
	}
	select(num:=""){
		Select:
		if A_GuiEvent!=I
			return
		Gui,85:Default
		this:=icon_browser.keep,number:=LV_GetNext()
		if(!number)
			return
		if(this.return){
			if(num="image"||this.close)
				hwnd({rem:85})
			func:=this.func,number:=num="image"?0:number,%func%({file:this.file,number:number,return:this.return})
			return
		}
		number:=num="image"?0:number,NumPut(VarSetCapacity(button,32),button,0),NumPut(0x1|0x20,button,4),NumPut(this.id,button,8),num:=this.tb.iconlist[this.file,number]!=""?this.tb.iconlist[this.file,number]:IL_Add(this.tb.imagelist,this.file,number)-1,this.tb.iconlist[this.file,number]:=num,NumPut(num,button,12)
		SendMessage,0x400+64,% this.id,&button,,% this.ahkid
		btn:=settings.ssn("//toolbar/bar[@id='" this.tb.id "']/button[@id='" this.id "']"),btn.setattribute("icon",number-1),btn.setattribute("file",this.file)
		if(this.close)
			hwnd({rem:85})
		if(this.focus)
			WinActivate,% this.focus
		return
	}
	load(filename:=""){
		loadfile:
		this:=icon_browser.keep
		if(!filename){
			FileSelectFile,filename,,,,*.exe;*.dll;*.png;*.jpg;*.gif;*.bmp;*.icl;*.ico
			if ErrorLevel
				return
		}
		this.file:=filename
		if filename contains .gif,.jpg,.png,.bmp
			return this.select("image")
		this.next(),settings.add2("icons").SetAttribute("last",filename),filename:=""
		return
	}
	exit(){
		for win in icon_browser.window
			Gui,%win%:Destroy
	}
	create(){
		this.il:=IL_Create(50,10,1)
	}
	next(){
		this:=icon_browser.keep
		if(A_ThisLabel="ibprev"&&this.start>=50)
			this.start:=this.start-100>=0?this.start-100:this.start-50
		start:=this.start,LV_Delete()
		GuiControl,85:-Redraw,SysListView321
		this.create(),LV_SetImageList(this.il)
		while,icon:=IL_Add(this.il,this.file,A_Index)
			LV_Add("Icon" icon)
		GuiControl,85:+Redraw,SysListView321
		return
	}
}