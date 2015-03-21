Add_Space_Before_Commas(){
	sc:=csc()
	if !sc.getseltext()
		return m("Please select some text")
	sc.2170(0,RegExReplace(sc.getseltext(),","," ,"))
}