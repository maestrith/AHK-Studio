Backspace(){
	Backspace:
	ControlGetFocus,Control,A
	if !InStr(Control,"Scintilla"){
		if InStr(A_ThisHotkey,"^"){
			GuiControl,1:-Redraw,Edit1
			Send,+^{Left}{Backspace}
			GuiControl,1:+Redraw,Edit1
		}
		return
	}
	if v.options.Disable_Auto_Delete
		return
	sc:=csc(),char:=Chr(sc.2007(sc.2008-1)),chnext:=chr(sc.2007(sc.2008))
	if auto:=settings.ff("//autoadd/key/@trigger",char)
		if (chnext=xml.ea(auto).add)
			sc.2645(sc.2008,1)
	return
}