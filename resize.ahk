resize(info*){
	static width,height,rheight,band,size:=[]
	if(info.1="other")
		return size.clone()
	if (A_Gui!=1){
		if(info.1="get")
			return size.clone()
		gui:=A_Gui?A_Gui:info.1,win:=WindowTracker.winlist[gui]
		if (info.1=0&&info.2=0&&win.ahkid){
			WinGetPos,x,y,,,% win.ahkid
			size[gui,"x"]:=x,size[gui,"y"]:=y
			return
		}
		static flip:={x:"w",y:"h"}
		if (info.2>>16){
			w:=info.2&0xffff,h:=info.2>>16
			if info.1!=2
				size[gui,"w"]:=w,size[gui,"h"]:=h
		}
		for a,b in win.tracker{
			orig:=win[b.control]
			for c,d in StrSplit(b.pos){
				if (d~="(w|h)")
					GuiControl,MoveDraw,% b.control,% d %d%-(b[d]-orig[d])
				if (d~="(x|y)"){
					val:=flip[d],offset:=orig[d]-b[val]
					GuiControl,MoveDraw,% b.control,% d %val%+offset
				}
			}
		}
	}
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
	ControlMove,,,,%width%,,% "ahk_id" rebar.hw.1.hwnd
	hh:=(height-h-v.StatusBar-2),max:=s.main.MaxIndex()
	x:=v.options.Hide_Project_Explorer?0:settings.get("//gui/@projectwidth",200)
	GuiControl,1:Move,SysTreeView321,x0 y%h% w%x% h%hh%
	ow:=add:=v.options.Hide_Code_Explorer?0:settings.get("//gui/@codewidth",200)
	add+=x
	widths:=(width-add)/max
	if (v.options.Split_Horizontal){
		totalwidth:=width-(x) ;for the width of the controls for horizontal split
		;hh is the total height available to split
		;t(totalwidth,x,ow)
		for a,b in s.main{
			GuiControl,-Redraw,% b.sc
			GuiControl,1:Move,% b.sc,% "x" x " y" h " w" widths " h" hh
			GuiControl,+Redraw,% b.sc
			;x+=widths
		}
		guicontrol,1:move,systreeview322,% "x" totalwidth " y" h "w" ow " h" hh
	}Else{
		for a,b in s.main{
			GuiControl,-Redraw,% b.sc
			GuiControl,1:Move,% b.sc,% "x" x " y" h "w" widths " h" hh
			GuiControl,+Redraw,% b.sc
			x+=widths
		}
		guicontrol,1:move,systreeview322,% "x" x " y" h "w" (width-x) " h" hh
	}
	GuiControl,+Redraw,% v.sbhwnd
	return
}