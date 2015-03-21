move_selected_lines_down(){
	GuiControl,-Redraw,% csc().sc
	csc().2621
	if (v.options.full_auto)
		newindent(settings.ssn("//tab").text?settings.ssn("//tab").text:5)
	GuiControl,+Redraw,% csc().sc
}