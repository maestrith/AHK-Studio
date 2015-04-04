bracesetup(win=1){
	static oldkeys:=[]
	for a in oldkeys
		Hotkey,%a%,brace,Off
	v.brace:=[],autoadd:=settings.sn("//autoadd/*"),test:=settings.ssn("//autoadd/*/@trigger").text
	if test is number
	{
		while,aa:=autoadd.item[A_Index-1],ea:=xml.ea(aa)
			aa.SetAttribute("trigger",Chr(ea.trigger)),aa.SetAttribute("add",Chr(ea.add))
	}
	Hotkey,IfWinActive,% hwnd([win])
	v.braceadvance:=[],oldkeys:=[]
	while,aa:=autoadd.item(a_index-1),ea:=xml.ea(aa){
		if (ea.trigger){
			insert:=[]
			Hotkey,% ea.trigger,brace,On
			v.brace[ea.trigger]:=ea.add,v.braceadvance[ea.add]:=Asc(ea.add),oldkeys[ea.trigger]:=1
			if(ea.trigger!=ea.add){
				Hotkey,% ea.add,brace,On
				oldkeys[ea.Add]:=1
			}
			v.brace[ea.trigger]:=ea.add
		}
	}
}