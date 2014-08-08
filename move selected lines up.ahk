move_selected_lines_up(){
	GuiControl,-Redraw,% csc().sc
	csc().2620
	if (v.options.full_auto){
		SetTimer,move_selected,20
		Sleep,50
	}
	GuiControl,+Redraw,% csc().sc
}