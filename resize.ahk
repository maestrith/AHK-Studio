Resize(info*){
	static width,height,rheight,band,size:=[]
	sc:=csc()
	if(info.1="other")
		return size.clone()
	if(i:=GuiKeep.current(A_Gui)){
		wid:=info.2&0xffff,hei:=info.2>>16
		if(wid=""||hei="")
			return
		for a,b in i.gui
			for c,d in b{
				if(c~="y|h")
					GuiControl,MoveDraw,%a%,% c hei+d
				else
					GuiControl,MoveDraw,%a%,% c wid+d
			}
		return
	}
	if(A_Gui!=1){
		if(A_Gui=85)
			SendMessage,0x1000+22,2,0,SysListView321,% hwnd([85])
		if(info.1="get")
			return size.clone()
		gui:=A_Gui?A_Gui:info.1,win:=WindowTracker.winlist[gui]
		if(info.1="getpos"){
			WinGetPos,x,y,,,% win.ahkid
			size[gui,"x"]:=x,size[gui,"y"]:=y
			return
		}
		static flip:={x:"w",y:"h"}
		if(info.2>>16){
			w:=info.2&0xffff,h:=info.2>>16
			if info.1!=2
				size[gui,"w"]:=w,size[gui,"h"]:=h
		}
		for a,b in win.tracker{
			orig:=win[b.control]
			for c,d in StrSplit(b.pos){
				if(d~="(w|h)")
					GuiControl,MoveDraw,% b.control,% d %d%-(b[d]-orig[d])
				if(d~="(x|y)"){
					val:=flip[d],offset:=orig[d]-b[val]
					GuiControl,MoveDraw,% b.control,% d %val%+offset
				}
			}
		}
	}
	if(info.1="get"){
		WinGetPos,x,y,,,% hwnd([1])
		return size:="x" x " y" y " w" width " h" height
	}
	if(A_Gui=1||info.1="rebar"){
		height:=info.2>>16?info.2>>16:height,width:=info.2&0xffff?info.2&0xffff:width
		SendMessage,0x400+27,0,0,,% "ahk_id" rebar.hw.1.hwnd
		rheight:=ErrorLevel
		SetTimer,rsize,-100
	}
	return
	rsize:
	WinGet,cl,ControlListHWND,% hwnd([1])
	ControlMove,,,,%width%,,% "ahk_id" rebar.hw.1.hwnd
	ControlGetPos,,y,,h,,% "ahk_id" rebar.hw.1.hwnd
	ControlGetPos,,,,eh,Edit1,% hwnd([1])
	hh:=height-v.status-rheight-v.menu
	v.options.Top_Find?(fy:=y+h,top:=y+h+eh):(fy:=hh+y+h,hh:=hh,top:=y+h)
	project:=v.options.Hide_Project_Explorer?0:settings.get("//gui/@projectwidth",200)
	code:=v.options.Hide_Code_Explorer?0:settings.get("//gui/@codewidth",200)
	start:=project
	for a,b in s.main
		GuiControl,-Redraw,% b.sc
	ControlMove,SysTreeView321,,%top%,%start%,%hh%,% hwnd([1])
	ControlMove,SysTreeView322,width-code+v.Border,top,,%hh%,% hwnd([1])
	div:=s.main.MaxIndex(),left:=width-(project+code)
	for a,b in s.main{
		ControlMove,,start+v.Border,top,% A_Index=div?(Floor(left/div)+(left-Floor(left/div)*div)):Floor(left/div),%hh%,% "ahk_id" b.sc
		start+=Floor(left/div)
	}
	ControlMove,Static1,,% fy+4,,,% hwnd([1])
	ControlMove,Edit1,,%fy%,% width-330,,% hwnd([1])
	Loop,4{
		if(A_Index=1){
			ControlGetPos,x,,w,,Edit1,% hwnd([1])
			start:=x+w+2
		}else{
			ControlGetPos,,,w,,% "Button" A_Index-1,% hwnd([1])
			start+=w+2
		}
		ControlMove,Button%A_Index%,%start%,% fy+4,,,% hwnd([1])
	}
	for a,b in s.main
		GuiControl,+Redraw,% b.sc
	WinSet,Redraw,,% hwnd([1])
	return
}