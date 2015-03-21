show_scintilla_code_in_line(){
	scintilla(),sc:=csc()
	text:=sc.textrange(sc.2128(sc.2166(sc.2008)),sc.2136(sc.2166(sc.2008))),pos:=1
	while,pos:=RegExMatch(text,"(\d\d\d\d)",found,pos){
		codes:=scintilla.sn("//*[@code='" found1 "']")
		list.="Code : " found1 " = "
		while,c:=codes.item(A_Index-1)
			list.=A_Index>1?" - " ssn(c,"@name").text:ssn(c,"@name").text
		pos+=5
		list.="`n"
	}
	if list
		m(Trim(list,"`n"))
}