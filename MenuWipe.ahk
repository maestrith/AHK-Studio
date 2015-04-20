MenuWipe(){
		all:=menus.sn("//*")
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
		parent:=ssn(aa.ParentNode,"@name").text,hotkey:=ssn(aa,"@hotkey").text,hotkey:=hotkey?"`t" convert_hotkey(hotkey):"",current:=ssn(aa,"@name").text
		Menu,%parent%,Delete,% current hotkey
	}
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa)
		if(aa.haschildnodes())
			Menu,main,Delete,% ea.name
}