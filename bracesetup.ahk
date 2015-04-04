bracesetup(win=1){
	static oldkeys:=[]
	for a in oldkeys
		Hotkey,%a%,brace,Off
	v.brace:=[],autoadd:=settings.sn("//autoadd/*")
	Hotkey,IfWinActive,% hwnd([win])
	v.braceadvance:=[],oldkeys:=[]
	while,aa:=autoadd.item(a_index-1),ea:=xml.ea(aa){
		if (ea.trigger){
			insert:=[]
			for c,d in {trigger:ea.trigger,add:ea.add}
				for e,f in StrSplit(d,",")
					Insert[c].=Chr(f)
			Hotkey,% insert.trigger,brace,On
			if(insert.trigger!=insert.add)
				Hotkey,% insert.add,brace,On
			v.braceadvance[insert.add]:=ea.add
			v.brace[insert.trigger]:=insert.add,oldkeys[insert.trigger]:=1
		}
	}
}