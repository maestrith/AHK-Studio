togglemenu(Label){
	if !Label
		return
	Menu,%A_ThisMenu%,ToggleCheck,%A_ThisMenuItem%
}