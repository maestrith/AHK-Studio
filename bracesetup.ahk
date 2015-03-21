bracesetup(win=1){
	static oldkeys:=[]
	for a in oldkeys
		Hotkey,%a%,brace,Off
	v.brace:=[],autoadd:=settings.sn("//autoadd/*")
	Hotkey,IfWinActive,% hwnd([win])
	v.braceadvance:=[],oldkeys:=[]
	while,aa:=autoadd.item(a_index-1),ea:=xml.ea(aa){
		if (ea.trigger){
			Hotkey,% Chr(ea.trigger),brace,On
			if(ea.trigger!=ea.add)
				Hotkey,% Chr(ea.add),brace,On
			v.braceadvance[Chr(ea.add)]:=ea.add
			v.brace[Chr(ea.trigger)]:=Chr(ea.add),oldkeys[Chr(ea.trigger)]:=1
		}
	}
}