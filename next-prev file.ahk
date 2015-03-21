next_prev_file(){
	next_file:
	TV_Modify(TV_GetNext(TV_GetSelection(),"F"),"Select Vis Focus")
	return
	previous_file:
	prev:=0,tv:=TV_GetSelection()
	while,tv!=prev:=TV_GetNext(prev,"F")
		newtv:=prev
	TV_Modify(newtv,"Select Vis Focus")
	return
}