Show_Class_Methods(object){
	static list
	ea:=xml.ea(cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Instance' and @upper='" upper(object) "']"))
	if ea.class{
		disp:=cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Class' and @upper='" upper(ea.class) "']")
		show:=sn(disp,"*[@type='Method' or @type='Property']"),list:=""
		while,ss:=show.item[A_Index-1],ea:=xml.ea(ss)
			list.=ea.text " "
		SetTimer,scl,-10
		return
		scl:
		if(list)
			csc().2117(3,Trim(list))
		return
	}
}