menu(menuname){
	menu:=menus.sn("//" menuname "/descendant::*"),list:=[]
	Menu,main,UseErrorLevel,On
	while,mm:=menu.item[A_Index-1]{
		route:="",ea:=xml.ea(mm)
		if !ea.clean
			mm.SetAttribute("clean",clean(ea.name))
		if IsLabel(clean(ea.name))
			route:=clean(ea.name)
		else if IsFunc(clean(ea.name))
			route:="menuroute"
		hotkey:=ea.hotkey?"`t" convert_hotkey(ea.hotkey):""
		if mm.childnodes.length>0
			list.Insert({menu:ea.name,under:clean(ssn(mm.ParentNode,"@name").Text)})
		else	if !clean(ssn(mm.ParentNode,"@name").text){
			list.Insert({top:ea.name,route:route})
			continue
		}else{
			name:=clean(ssn(mm.ParentNode,"@name").text)
			if (mm.nodename="separator"){
				Menu,%name%,Add
				continue
			}
			if !route
				Continue
			Menu,%name%,Add,% ea.name hotkey,%route%
			if value:=settings.ssn("//*/@" clean(ea.name)).text{
				Menu,% name,Check,% ea.name hotkey
				v.options[clean(ea.name)]:=value
			}
		}
	}
	for a,b in list{
		if b.top{
			Menu,%menuname%,Add,% b.top,% b.route
			continue
		}
		b.under:=b.under?b.under:menuname
		Menu,% b.under,Add,% b.menu,% ":" clean(b.menu)
	}
	return menuname
	menuroute:
	item:=clean(A_ThisMenuItem)
	%item%()
	return
	show:
	WinActivate,% hwnd([1])
	return
}