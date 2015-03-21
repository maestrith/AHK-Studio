refreshthemes(){
	refresh(),theme:=csc(1)
	Loop,31
		v.theme.2409(A_Index,1)
	ea:=settings.ea("//fonts/font[@style='5']")
	hwnd:=hwnd("get")
	for win,b in hwnd{
		if win>99
			return
		winget,controllist,ControlList,% "ahk_id" b
		Gui,%win%:Default
		Gui,%win%:font,% "c" RGB(ea.color) " s" ea.size,% ea.font
		loop,Parse,ControlList,`n
		{
			if (win=1&&A_LoopField="Edit1")
				Gui,1:font,% "Normal s10",% ea.font
			GuiControl,% "+background" RGB(ea.Background) " c" rgb(ea.color),%A_LoopField%
			GuiControl,% "font",%A_LoopField%
		}
	}
}