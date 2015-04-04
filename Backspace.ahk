Backspace(){
	Backspace:
	sc:=csc(),char:=Chr(sc.2007(sc.2008-1)),chnext:=chr(sc.2007(sc.2008))
	if auto:=settings.ff("//autoadd/key/@trigger",char)
		if (chnext=xml.ea(auto).add)
			sc.2645(sc.2008,1)
	return
}