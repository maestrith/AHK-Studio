window(info){
	static
	static variables:=[]
	if info.get{
		vars:=[],win:=info.get
		Gui,%win%:Submit,Nohide
		for a,b in variables[info.get]
			vars[a]:=%a%
		return vars
	}
	for a,b in info.gui{
		StringSplit,b,b,`,
		Gui,Add,%b1%,%b2% hwndpoo,%b3%
		RegExMatch(b2,"U)\bv(.*\b)",found)
		b2:=b3:=""
		if found1
			variables[info.win,found1]:=1
	}
}