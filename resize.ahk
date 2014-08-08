resize(info*){
	static width,height,rheight,band
	if (info.1="get"){
		WinGetPos,x,y,,,% hwnd([1])
		return size:="x" x " y" y " w" width " h" height
	}
	if (A_Gui=1){
		height:=info.2>>16?info.2>>16:height,width:=info.2&0xffff?info.2&0xffff:width
		SendMessage,0x400+27,0,0,,% "ahk_id" rebar.hw.1.hwnd
		rheight:=ErrorLevel
	}
	ControlGetPos,,y,,h,,% "ahk_id" rebar.hw.1.hwnd
	yoffset:=y+h
	ControlMove,,,,%width%,,% "ahk_id" rebar.hw.1.hwnd
	hh:=(height-h-v.StatusBar-2),max:=s.main.MaxIndex()
	x:=v.options.Hide_Project_Explorer?0:settings.get("//gui/@projectwidth",200)
	GuiControl,1:Move,SysTreeView321,x0 y%h% w%x% h%hh%
	add:=v.options.Hide_Code_Explorer?0:settings.get("//gui/@codewidth",200)
	add+=x
	widths:=(width-add)/max
	for a,b in s.main{
		GuiControl,-Redraw,% b.sc
		GuiControl,1:Move,% b.sc,% "x" x " y" h "w" widths " h" hh
		GuiControl,+Redraw,% b.sc
		x+=widths
	}
	guicontrol,1:move,systreeview322,% "x" x " y" h "w" (width-x) " h" hh
	GuiControl,+Redraw,% v.sbhwnd
	return
}