move_selected_lines_down(){
	GuiControl,-Redraw,% csc().sc
	csc().2621
	if (v.options.full_auto)
		newindent(1)
	GuiControl,+Redraw,% csc().sc
}