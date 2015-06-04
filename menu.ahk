menu(menuname){
	menu:=menus.sn("//" menuname "/descendant::*"),topmenu:=menus.sn("//" menuname "/*")
	Menu,main,UseErrorLevel,On
	while,mm:=topmenu.item[A_Index-1],ea:=xml.ea(mm)
		if mm.haschildnodes()
			Menu,% ea.name,DeleteAll
	Menu,main,DeleteAll
	while,mm:=topmenu.item[A_Index-1],eamm:=xml.ea(mm){
		if(mm.nodename="date"||eamm.hide)
			Continue
		children:=sn(mm,"*")
		while,cc:=children.item[A_Index-1],cea:=xml.ea(cc){
			icon:=""
			if(cc.nodename="date"||cea.hide)
				Continue
			if(cc.nodename="separator"){
				parent:=ssn(cc.ParentNode,"@name").text
				Menu,%parent%,Add
				Continue
			}
			if(cc.haschildnodes()&&ssn(cc,"ancestor-or-self::menu[@clean='Plugin']").xml=""){
				list:=[],sub:=sn(cc,"descendant-or-self::*")
				while,pp:=sub.item[A_Index-1]
					if pp.haschildnodes()
						list.Insert(pp)
				Loop,% list.MaxIndex(){
					item:=List[list.MaxIndex()-(A_Index-1)],lll:=sn(item,"*")
					while,ll:=lll.item[A_Index-1],llea:=xml.ea(ll){
						parent:=ssn(ll.ParentNode,"@name").text,current:=llea.name
						if ll.haschildnodes()
							Menu,%parent%,Add,%current%,:%current%
						else{
							hotkey:=ssn(ll,"@hotkey").text,hotkey:=hotkey?"`t" convert_hotkey(hotkey):"",ea:=xml.ea(ll)
							if(ea.hide)
								Continue
							if !(IsFunc(clean(current))||IsLabel(clean(current)))
								if !FileExist("plugins\" ea.plugin)
									Continue
							Menu,%parent%,Add,% current hotkey,MenuRoute
							if(llea.filename)
								Menu,%parent%,Icon,% current hotkey,% llea.filename,% llea.icon
							if value:=settings.ssn("//*/@" clean(current)).text{
								Menu,%parent%,Check,% current hotkey
								v.options[clean(current)]:=value
							}
						}
					}
				}
				Menu,% ssn(cc.ParentNode,"@name").text,Add,%parent%,:%parent%
				if(cea.filename)
					Menu,% ssn(cc.ParentNode,"@name").text,Icon,%parent%,% cea.filename,% cea.icon
			}else{
				if(cea.hide)
					Continue
				current:=ssn(cc,"@name").text,parent:=ssn(cc.ParentNode,"@name").text,hotkey:=ssn(cc,"@hotkey").text,hotkey:=hotkey?"`t" convert_hotkey(hotkey):"",ea:=xml.ea(cc)
				if !(IsFunc(clean(current))||IsLabel(clean(current))){
					if !ea.plugin
						Continue
				}
				Menu,%parent%,Add,% current hotkey,MenuRoute
				if(cea.filename)
					Menu,%parent%,Icon,% current hotkey,% cea.filename,% cea.icon
				if value:=settings.ssn("//*/@" clean(current)).text{
					Menu,%parent%,Check,% current hotkey
					v.options[clean(current)]:=value
				}
			}
		}
	}
	while,tt:=topmenu.item[A_Index-1],ea:=xml.ea(tt){
		if tt.haschildnodes(){
			if(ea.hide)
				Continue
			Menu,%menuname%,Add,% ea.name,% ":" ea.name
			if(ea.filename){
				Menu,%menuname%,icon,% ea.filename,% ea.icon
				m(ea.filename,ea.Icon)
			}
		}
		else{
			if(ea.hide)
				Continue
			Menu,%menuname%,Add,% ea.name,% ":" ea.name
			if(ea.filename){
				Menu,%menuname%,icon,% ea.filename,% ea.icon
				m(ea.filename,ea.Icon)
			}
		}
	}
	return menuname
	MenuRoute:
	item:=clean(A_ThisMenuItem),ea:=menus.ea("//*[@clean='" item "']"),plugin:=ea.plugin,option:=ea.option
	if(plugin){
		Run,"%plugin%" %option%
		return
	}
	if IsFunc(item)
		%item%()
	else
		SetTimer,%item%,-1
	return
	show:
	WinActivate,% hwnd([1])
	return
}