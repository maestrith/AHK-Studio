menu(menuname){
	menu:=menus.sn("//" menuname "/descendant::*"),topmenu:=menus.sn("//" menuname "/*")
	Menu,main,UseErrorLevel,On
	while,mm:=topmenu.item[A_Index-1]{
		children:=sn(mm,"*")
		while,cc:=children.item[A_Index-1]{
			if cc.haschildnodes(){
				list:=[],sub:=sn(cc,"descendant-or-self::*")
				while,pp:=sub.item[A_Index-1]
					if pp.haschildnodes()
						list.Insert(pp)
				Loop,% list.MaxIndex(){
					item:=List[list.MaxIndex()-(A_Index-1)],lll:=sn(item,"*")
					while,ll:=lll.item[A_Index-1]{
						parent:=ssn(ll.ParentNode,"@name").text,current:=ssn(ll,"@name").text
						if ll.haschildnodes()
							Menu,%parent%,Add,%current%,:%current%
						else{
							hotkey:=ssn(ll,"@hotkey").text,hotkey:=hotkey?"`t" convert_hotkey(hotkey):""
							Menu,%parent%,Add,% current hotkey,menuroute
							if value:=settings.ssn("//*/@" clean(current)).text{
								Menu,%parent%,Check,% current hotkey
								v.options[clean(current)]:=value
							}
						}
					}
				}
				Menu,% ssn(cc.ParentNode,"@name").text,Add,%parent%,:%parent%
			}else{
				current:=ssn(cc,"@name").text,parent:=ssn(cc.ParentNode,"@name").text,hotkey:=ssn(cc,"@hotkey").text,hotkey:=hotkey?"`t" convert_hotkey(hotkey):""
				Menu,%parent%,Add,% current hotkey,menuroute
				if value:=settings.ssn("//*/@" clean(current)).text{
					Menu,%parent%,Check,% current hotkey
					v.options[clean(current)]:=value
				}
			}
		}
	}
	while,tt:=topmenu.item[A_Index-1]{
		menu:=ssn(tt,"@name").text
		if tt.haschildnodes()
			Menu,%menuname%,Add,%menu%,:%menu%
		else
			Menu,%menuname%,Add,%menu%,menuroute
	}
	return menuname
	menuroute:
	item:=clean(A_ThisMenuItem)
	if IsFunc(item)
		%item%()
	else
		SetTimer,%item%,-1
	return
}