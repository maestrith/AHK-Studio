move_selected_lines_down(){
	GuiControl,-Redraw,% csc().sc
	csc().2621
	if (v.options.full_auto){
		SetTimer,move_selected,20
		Sleep,50
	}
	GuiControl,+Redraw,% csc().sc
}