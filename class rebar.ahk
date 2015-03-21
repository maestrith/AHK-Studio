class rebar{
	static hw:=[],keep:=[]
	__New(win=1,hwnd="",special=""){
		static id:=0
		id:=hwnd.id?hwnd.id:++id
		this.id:=id
		code:=0x10000000|0x40000000
		code|=0x200|0x400|0x8000|0x2000|0x40
		Gui,%win%:Add,custom,ClassReBarWindow32 hwndrhwnd w500 h400 +%code% Background0 grebar
		this.hwnd:=rhwnd,this.count:=count
		this.keep[rhwnd]:=this
		this.ahkid:="ahk_id" rhwnd
		v.rebarahkid:=this.ahkid
		this.parent:=hwnd
		Loop,2
			SendMessage,0x400+19,0,0xff0000,,% this.ahkid
		rebar.hw.insert(this)
	}
	hide(id){
		SendMessage,0x400+16,id,0,,% this.ahkid ;RB_IDTOINDEX
		SendMessage,0x400+35,%errorlevel%,0,,% this.ahkid ;RB_SHOWBAND
	}
	show(id){
		SendMessage,0x400+16,id,0,,% this.ahkid ;RB_IDTOINDEX
		SendMessage,0x400+35,%errorlevel%,1,,% this.ahkid ;RB_SHOWBAND
	}
	add(gui,style="",mask=132){
		static id:=10000,struct:={hwnd:32,height:40,width:44,id:52,max:60,int:64,ideal:68}
		mask|=0x20|0x100|0x2|0x10|0x200|0x40|0x08|0x1|0x4|0x80
		style|=0x4|0x200|0x80
		if gui.max
			style|=0x40
		VarSetCapacity(BAND,80,0)
		if gui.label
			VarSetCapacity(BText,StrLen(gui.label)*2),StrPut(gui.label,&BText,"utf-8")
		win:=gui.win?gui.win:1
		NumPut(225525,band,12)
		if hwnd:=toolbar.list[gui.id].hwnd
			gui.hwnd:=hwnd
		if hh:=toolbar.list[gui.id].barinfo().height
			gui.height:=hh
		for a,b in gui{
			if struct[a]
				NumPut(b,band,struct[a])
		}
		for a,b in {0:80,4:mask,8:style,20:&BText}
			if b
				NumPut(b,band,a)
		SendMessage,0x400+1,-1,&BAND,,% "ahk_id" this.hwnd
	}
	getpos(hwnd){
		ControlGetPos,x,y,w,h,,ahk_id%hwnd%
		return {x:x,y:y,w:w,h:h}
	}
	save(){
		lasttop:=0
		for a,b in rebar.hw{
			vis:=settings.sn("//rebar/band/@vis")
			top:=settings.ssn("//rebar")
			while,vv:=vis.item[A_Index-1]
				vv.text:=0
			newline:=sn(top,"newline")
			while,new:=newline.item[A_Index-1]
				new.parentnode.removechild(new)
			SendMessage,0x400+12,0,0,,% b.ahkid ;RB_GETBANDCOUNT
			Loop,%ErrorLevel%{
				NumPut(VarSetCapacity(band,80),&band,0),NumPut(0x140,&band,4) ;get the width and id of the band
				SendMessage,0x400+28,% A_Index-1,&band,,% b.ahkid ;RB_GETBANDINFOW
				id:=NumGet(&band,52)
				VarSetCapacity(rect,16)
				SendMessage,0x400+9,% A_Index-1,&rect,,% b.ahkid ;RB_GETRECT
				y:=NumGet(rect,4),width:=NumGet(rect,8)-NumGet(rect,0)
				if (y>lasttop)
					settings.under(top,"newline",{vis:1})
				lasttop:=y
				next:=settings.ssn("//rebar/band[@id='" id "']"),next.SetAttribute("width",width)
				next.setattribute("vis",1),next.parentnode.appendchild(next)
			}
		}
	}
	notify(){
		rebar:
		code:=NumGet(A_EventInfo,8,"int")
		this:=rebar.keep[NumGet(A_EventInfo)]
		if (code=-841)
			m("Chevron Pushed")
		if (code=-831&&NumGet(A_EventInfo)=this.hwnd){
			Resize()
			GuiControl,1:+Redraw,SysTreeView321
		}
		if (code=-841){
			NumPut(VarSetCapacity(band,80),band,0)
			NumPut(0x10,band,4)
			bd:=NumGet(A_EventInfo+12)
			SendMessage,0x400+28,%bd%,&band,,% this.ahkid
			childwindowhwnd:=NumGet(band,32)
		}
		return
	}
}