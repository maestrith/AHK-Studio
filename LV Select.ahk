LV_Select(win,add){
	Gui,%win%:Default
	next:=LV_GetNext()+Add
	LV_Modify(next>0&&next<=LV_GetCount()?next:LV_GetNext(),"Select Vis Focus")
}