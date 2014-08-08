changehotkey(){
	static hk,hotkey,hwnd,ehk
	Gui,2:Default
	hotkey:=menus.ssn("//*[@tv='" TV_GetSelection() "']")
	setup(98,1)
	Gui,Add,Hotkey,gehk vhk Limit1 hwndhwnd,% ssn(Hotkey,"@hotkey").text
	Gui,Add,Text,,Or enter hotkey below (eg ^+F)
	Gui,Add,Edit,w200 gclearhk vehk
	Gui,Show,,Hotkey
	return
	ehk:
	Gui,98:Submit,NoHide
	Hotkey.setattribute("hotkey",hk),Hotkey.setattribute("last",1)
	return
	clearhk:
	Gui,98:Submit,NoHide
	GuiControl,,%hwnd%,%ehk%
	goto ehk
	return
}