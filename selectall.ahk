selectall(){
	selectall:
	ControlGetFocus,Focus,A
	if (!InStr(Focus,"Scintilla")){
		Send,^A
		return
	}
	sc:=csc(),count:=Abs(sc.2008-sc.2009)
	if v.selectedduplicates{
		for a,b in v.selectedduplicates
			if A_Index=1
				sc.2160(b+count,b)
		else
			sc.2573(b,b+count)
	}
	Else
		sc.2013
	return
}