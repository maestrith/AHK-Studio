Class PluginClass{
	Close:=[]
	__New(){
		return this
	}
	file(){
		return A_ScriptFullPath
	}
	SetTimer(timer,period:=-1){
		period:=period>0?-period:period
		SetTimer,%timer%,%period%
	}
	AutoClose(script){
		if !this.Close[script]
			this.Close[script]:=1
	}
	Color(con){
		v.con:=con
		SetTimer,Color,-1
		Sleep,10
		v.con:=""
	}
	update(filename,text){
		update({file:filename,text:text})
	}
	Show(){
		sc:=csc()
		WinActivate,% hwnd([1])
		GuiControl,+Redraw,% sc.sc
		setpos(sc.2357),sc.2400
	}
	Style(){
		return ea:=settings.ea(settings.ssn("//fonts/font[@style='5']")),ea.color:=RGB(ea.color),ea.Background:=RGB(ea.Background)
	}
	TrayTip(info){
		if(SubStr(A_OSVersion,1,3)="10.")
			m(info)
		else
			TrayTip,AHK Studio,%info%,2
	}
	EnableSC(x:=0){
		sc:=csc()
		if(x){
			GuiControl,1:+Redraw,% sc.sc
			GuiControl,1:+gnotify,% sc.sc
		}else{
			GuiControl,1:-Redraw,% sc.sc
			GuiControl,1:+g,% sc.sc
		}
	}
	Publish(info:=0){
		return Publish(info)
	}
	Hotkey(win:=1,key:="",label:="",on:=1){
		if !(win,key,label)
			return m("Unable to set hotkey")
		Hotkey,IfWinActive,% hwnd([win])
		Hotkey,%key%,%label%,% _:=on?"On":"Off"
	}
	WindowTracker(win){
		return new WindowTracker(win)
	}
	save(){
		save()
	}
	sc(){
		return csc()
	}
	hwnd(win:=1){
		return hwnd(win)
	}
	get(name){
		return _:=%name%
	}
	tv(tv){
		return tv(tv)
	}
	Current(x){
		return current(x)
	}
	m(info*){
		m(info*)
	}
	allctrl(code,lp,wp){
		for a,b in s.ctrl
			b[code](lp,wp)
	}
	dynarun(script){
		return dynarun(script)
	}
	call(info*){
		;this can cause major errors
		if(IsFunc(info.1)&&info.1~="i)(Fix_Indent|newindent)"=0){
			func:=info.1,info.Remove(1)
			return %func%(info*)
		}
		SetTimer,% info.1,-100
	}
	activate(){
		WinActivate,% hwnd([1])
	}
	refresh(){
		
	}
	open(info){
		tv:=open(info),tv(tv)
	}
	GuiControl(info*){
		GuiControl,% info.1,% info.2,% info.3
	}
	ssn(node,path){
		return node.SelectSingleNode(path)
	}
	__Call(x*){
		m(x)
	}
}