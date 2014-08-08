setup(window,nodisable=""){
	ea:=settings.ea(settings.ssn("//fonts/font[@style='5']"))
	Background:=ea.Background,font:=ea.font,color:=RGB(ea.color)
	Background:=Background?Background:0
	size:=10
	Gui,%window%:Destroy
	Gui,%window%:Default
	Gui,+hwndhwnd
	if !nodisable{
		Gui,+Owner1 -0x20000
		Gui,1:+Disabled
	}
	Gui,+Owner1
	Gui,color,% RGB(Background),% RGB(Background)
	Gui,Font,% "s" size " c" color " bold",%font%
	Gui,%window%:Default
	v.window[window]:=1,hwnd(window,hwnd)
	return hwnd
}