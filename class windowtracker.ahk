class WindowTracker{
	static winlist:=[],set:=[],defaulttext:="i)(versioninfo)"
	__New(win){
		OnMessage(0x232,"Resize"),hwnd:=setup(win)
		this.win:=win,this.hwnd:=hwnd,this.ahkid:="ahk_id" hwnd,this.type:=[]
		this.tracker:=[],this.resize:=[],WindowTracker.winlist[win]:=this,this.varlist:=[]
		WindowTracker.set:=new xml("window","lib\Window.xml")
		for a,b in {border:32,caption:4}{
			SysGet,%a%,%b%
			this[a]:=%a%
		}
		return this
	}
	root(){
		if !window:=WindowTracker.set.ssn("//window/window[@name='" this.win "']")
			window:=WindowTracker.set.Add2("window/window",{name:this.win},"",1)
		return window
	}
	Theme(Background,forground,font="Fixedsys",size=12){
		winget,controllist,ControlList,% this.ahkid
		Gui,% this.win ":font",% "c" forground " s" size,%font%
		Gui,% this.win ":Color",%Background%,%Background%
		for a,b in StrSplit(controllist,"`n"){
			Gui,% this.win ":font",% "Normal s" size,% font
			GuiControl,% "+background" Background " c" color,%b%
			GuiControl,% this.win ":font",%b%
		}
	}
	Show(title:="",position=""){
		Gui,% this.win ":Show",Hide
		for a,b in this.resize
			this.track(b.control,b.pos)
		Gui,% this.win ":+MinSize"
		root:=this.root()
		for a,b in ["x","y","w","h"]{
			var:=ssn(root,"@" b).text
			if (var=""){
				pos:=""
				Break
			}
			pos.=b var " "
		}
		if position=1
			pos:=Center(this.win)
		else
			pos:=position?position:pos
		Gui,% this.win ":Show",%pos% %AutoSize%,%title%
		if ssn(root,"@minmax").text
			WinMaximize,% this.ahkid
	}
	track(control,pos){
		ControlGetPos,x,y,w,h,,ahk_id%control%
		for a,b in {x:x,y:y,w:w,h:h}{
			sub:=a="x"?this.border:a="y"?this.caption+this.border:0
			this[control,a]:=b-sub
		}
		VarSetCapacity(size,16,0),DllCall("user32\GetClientRect","uint",this.hwnd,"uint",&size),ww:=NumGet(size,8),hh:=NumGet(size,12)
		this.tracker.Insert({control:control,pos:pos,w:ww,h:hh})
	}
	Add(control){
		for a,b in Control{
			b:=StrSplit(b,",")
			RegExMatch(b.2,"U)\bv(.*)\b",variable)
			if (variable1)
				hwnd:=this.vars(b,variable1)
			Else
				Gui,% this.win ":Add",% b.1,% b.2 " hwndhwnd",% b.3
			if (b.1~="i)(ComboBox|DDL|DropDownList)"&&info!="Error")
				GuiControl,% this.win ":ChooseString",%hwnd%,%info%
			this[variable1]:=hwnd
			this.type[variable1]:=control.1
			if b.4{
				Gui,% this.win ":+Resize"
				this.resize.Insert({control:hwnd,pos:b.4})
			}
		}
	}
	vars(control="",var=""){
		static
		if IsObject(control){
			this.varlist.Insert(var)
			Gui,% this.win ":Add",% control.1,% control.2 " hwndhwnd",% control.3
			return hwnd
		}if Control{
			Gui,% this.win ":Submit",NoHide
			return _:=%control%
		}Else{
			list:=[]
			for a,b in this.varlist{
				Gui,% this.win ":Submit",NoHide
				ControlGet,check,Checked,,,% "ahk_id" this[b]
				List[b]:=%b%
			}
			return list
		}
	}
	Destroy(){
		hwnd({rem:this.win})
	}
	__Get(a*){
		return this.vars()
	}
	Exit(win){
		size:=Resize("other")
		if !WindowTracker.winlist[win]
			return
		cw:=WindowTracker.winlist[win]
		root:=cw.root()
		for a,b in size[win]
			root.SetAttribute(a,b)
		WinGet,MinMax,MinMax,% cw.ahkid
		root.SetAttribute("minmax",minmax)
		WindowTracker.set.save(1)
	}
}