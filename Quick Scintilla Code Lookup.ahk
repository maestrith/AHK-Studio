Quick_Scintilla_Code_Lookup(){
	static list
	sc:=csc(),word:=sc.getword()
	StringUpper,word,word
	if !(list)
		list:=scintilla(1)
	ea:=scintilla.ea("//commands/item[@name='" word "']")
	if ea.code{
		syn:=ea.syntax?ea.code "()":ea.code,sc.2160(start,end),sc.2170(0,[syn])
		if ea.syntax
			sc.2025(sc.2008-1),sc.2200(start,ea.code ea.syntax)
		return
	}
	slist:=scintilla.sn("//commands/item[contains(@name,'" word "')]"),ll:=""
	while,sl:=slist.item[A_Index-1]
		ll.=ssn(sl,"@name").text " "
	sc.2117(1,Trim(ll))
	sc.2645(start,end-start)
}