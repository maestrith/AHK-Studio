changehotkey(){
	static hk,hotkey,hwnd,ehk
	Gui,2:Default
	hotkey:=menus.ssn("//*[@tv='" TV_GetSelection() "']")
	setup(98,1)
	Gui,Add,Hotkey,gehk vhk Limit1 hwndhwnd,% ssn(Hotkey,"@hotkey").text
	Gui,Add,Text,,Or enter hotkey below (eg ^+F)
	Gui,Add,Edit,w200 gclearhk vehk
	Gui,Add,Button,gchcancel,Cancel
	Gui,Add,Button,x+10 gchksub,Submit
	Gui,Show,,Hotkey
	return
	ehk:
	Gui,98:Submit,NoHide
	Hotkey.setattribute("hotkey",hk),Hotkey.setattribute("last",1)
	Gui,2:Default
	name:=RegExReplace(ssn(hotkey,"@clean").text,"_"," ")
	ControlGet,list,list,,SysListView321,% hwnd([2])
	pos:=RegExMatch(list,"\b" name "\b")
	text:=SubStr(list,1,pos),RegExReplace(text,"\n","",Count)
	LV_Modify(count+1,"Col2",convert_hotkey(hk))
	return
	clearhk:
	Gui,98:Submit,NoHide
	GuiControl,,%hwnd%,%ehk%
	goto ehk
	return
	chcancel:
	Gui,98:Destroy
	return
	chksub:
	SetTimer,98GuiEscape,-1
	return
}