move_selected_lines_up(){
	GuiControl,-Redraw,% csc().sc
	csc().2620
	if (v.options.full_auto)
		newindent(1)
	GuiControl,+Redraw,% csc().sc
}