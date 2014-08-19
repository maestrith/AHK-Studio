next_prev_file(){
	next_file:
	if tv:=TV_GetChild(TV_GetSelection())
		tv(tv)
	Else if tv:=TV_GetNext(TV_GetSelection())
		tv(tv)
	Else{
		if tv:=TV_GetNext(TV_GetParent(TV_GetSelection()))
			tv(tv)
	}
	return
	previous_file:
	if !TV_GetPrev(TV_GetSelection()){
		if tv:=TV_GetParent(TV_GetSelection())
			tv(tv)
	}
	else if search:=TV_GetChild(TV_GetPrev(TV_GetSelection())){
		while,search:=TV_GetNext(search)
			last:=search
		tv(last)
	}Else if tv:=TV_GetPrev(TV_GetSelection()){
		tv(tv)
	}
	return
}