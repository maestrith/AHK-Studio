refreshthemes(){
	refresh(),theme:=csc(1)
	Loop,31
		v.theme.2409(A_Index,1)
	if(node:=settings.ssn("//fonts/custom[@gui='1' and @control='msctls_statusbar321']"))
		SetStatus(node)
	else
		SetStatus(settings.ssn("//fonts/font[@style='5']"))
	default:=ea:=settings.ea("//fonts/font[@style='5']")
	for win,b in hwnd("get"){
		if win>99
			return
		winget,controllist,ControlList,% "ahk_id" b
		Gui,%win%:Default
		Gui,Color,% RGB(ea.Background),% RGB(ea.Background)
		loop,Parse,ControlList,`n
		{
			if(A_LoopField~="i)Static1|Button")
				Continue
			if (win=1&&A_LoopField="Edit1")
				Gui,1:font,% "Normal s10 c" RGB(ea.Color),% ea.font
			else{
				if(node:=settings.ssn("//fonts/custom[@gui='" win "' and @control='" A_LoopField "']"))
					text:=CompileFont(node),ea:=xml.ea(node)
				else
					text:=CompileFont(node:=settings.ssn("//fonts/font[@style='5']")),ea:=xml.ea(node)
				Gui,%win%:font,%text%,% ea.font
			}
			GuiControl,% "+background" RGB(ea.Background!=""?ea.Background:default.Background) " c" rgb(ea.color),%A_LoopField%
			GuiControl,% "font",%A_LoopField%
		}
	}
}