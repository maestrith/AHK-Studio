testing(){
	;m("testing")
	sc:=csc()
	info:=StrSplit(sc.getseltext(),",")
	replace:=info.2 ":=InputBox(," Chr(34) info.3 Chr(34) "," Chr(34) info.4 Chr(34) "," Chr(34) info.12 Chr(34) ")"
	sc.2170(0,replace)
}

class WindowTracker{
	winlist:=[]
	__New(win){
		DetectHiddenWindows,On
		OnMessage(0x232,"Resize")
		Gui,%win%:+hwndhwnd
		this.win:=win,this.hwnd:=hwnd,this.ahkid:="ahk_id" hwnd,this.type:=[]
		this.tracker:=[],this.resize:=[],WindowTracker.winlist[win]:=this,this.varlist:=[]
		for a,b in {border:32,caption:4}{
			SysGet,%a%,%b%
			this[a]:=%a%
		}
		return this
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
	Show(title:=""){
		Gui,% this.win ":Show",Hide
		for a,b in this.resize
			this.track(b.control,b.pos)
		Gui,% this.win ":+MinSize"
		for a,b in ["x","y","w","h"]{
			IniRead,var,settings.ini,% this.win,%b%
			if (var="error"||var=""){
				pos:=""
				Break
			}
			pos.=b var " "
		}
		Gui,% this.win ":Show",%pos%,%title%
		IniRead,minmax,settings.ini,% this.win,minmax,0
		if MinMax
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
			IniRead,info,settings.ini,% this.win " Variables",%variable1%
			if (b.5&&b.1!="Checkbox"){
				b.3:=info="Error"?"":info
			}Else if (b.1~="i)(Checkbox|Radio)"&&info!="Error"){
				b.2.=info?" Checked":""
			}
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
	__Get(a*){
		return this.vars()
	}
	Exit(win){
		size:=Resize("other")
		for a,b in WindowTracker.winlist{
			if (a!=win)
				continue
			for c,d in b.vars{
				if (b.type[c]~="i)(Checkbox|Radio)")
					ControlGet,d,Checked,,,% "ahk_id" b[c]
				IniWrite,%d%,settings.ini,% b.win " Variables",%c%
			}
			WinGet,MinMax,MinMax,% b.ahkid
			IniWrite,%minmax%,settings.ini,% b.win,MinMax
			for c,d in size[b.win]
				IniWrite,%d%,settings.ini,% b.win,%c%
		}
		;ExitApp
	}
}