scintilla_code_lookup(){
	static slist,cs,newwin
	scintilla(),slist:=scintilla.sn("//commands/item")
	newwin:=new windowtracker(8)
	newwin.Add(["Edit,Uppercase w500 gcodesort vcs,,w","ListView,w720 h500 -Multi,Name|Code|Syntax,wh","Radio,xm Checked gcodesort,Commands,y","Radio,x+5 gcodesort,Constants,y","Button,xm ginsert Default,Insert code into script,y","Button,gdocsite,Goto Scintilla Document Site,y"])
	while,sl:=slist.item(A_Index-1)
		LV_Add("",ssn(sl,"@name").text,ssn(sl,"@code").text,ssn(sl,"@syntax").text)
	newwin.Show("Scintilla Code Lookup")
	Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	hotkeys([8],{up:"sclup",down:"scldn"})
	return
	sclup:
	scldn:
	return lv_select(8,A_ThisLabel="sclup"?-1:1)
	docsite:
	Run,http://www.scintilla.org/ScintillaDoc.html
	return
	codesort:
	cs:=newwin[].cs
	Gui,8:Default
	GuiControl,-Redraw,SysListView321
	LV_Delete()
	for a,b in {1:"commands",2:"constants"}{
		ControlGet,check,Checked,,Button%a%,% hwnd([8])
		value:=b
		if Check
			break
	}
	slist:=scintilla.sn("//" value "/*[contains(@name,'" cs "')]")
	while,(sl:=xml.ea(slist.item(A_Index-1))).name
		LV_Add("",sl.name,sl.code,sl.syntax)
	LV_Modify(1,"Select Vis Focus")
	GuiControl,+Redraw,SysListView321
	return
	insert:
	LV_GetText(code,LV_GetNext(),2),sc:=csc(),DllCall(sc.fn,"Ptr",sc.ptr,"UInt",2003,int,sc.2008,astr,code,"Cdecl")
	npos:=sc.2008+StrLen(code),sc.2160(npos,npos),hwnd({rem:8})
	return
	lookupud:
	Gui,8:Default
	count:=A_ThisHotkey="up"?-1:+1,pos:=LV_GetNext()+count<1?1:LV_GetNext()+count,LV_Modify(pos,"Select Focus Vis")
	return
	8GuiClose:
	8GuiEscape:
	hwnd({rem:8})
	return
}