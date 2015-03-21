Add_Selected_To_Personal_Variables(){
	sc:=csc(),vars:=settings.ssn("//Variables"),start:=sc.2585(0),end:=sc.2587(0)
	if(start=end)
		return m("Select some text first")
	text:=sc.textrange(start,end)
	if(ssn(vars,"Variable[text()='" text "']"))
		return m("Already there.")
	settings.under(vars,"Variable","",text),keywords()
}