Class PluginClass{
	Close:=[]
	__New(){
		return this
	}
	AutoClose(script){
		if !this.Close[script]
			this.Close[script]:=1
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
		TrayTip,AHK Studio,%info%,2
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
	m(info*){
		m(info*)
	}
	call(info*){
		;this can cause major errors
		if (IsFunc(info.1)&&info.1~="i)(Fix_Indent|newindent)"=0){
			func:=info.1,info.Remove(1)
			return %func%(info*)
		}
		SetTimer,% info.1,-100
	}
	activate(){
		WinActivate,% hwnd([1])
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
}