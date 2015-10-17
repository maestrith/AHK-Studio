Add_Toolbar(){
	bands:=settings.sn("//rebar/*")
	while,bb:=bands.item[A_Index-1],ea:=xml.ea(bb){
		if(ea.id&&ea.id!=11000)
			id:=ea.id+1
	}
	settings.add2("toolbar/bar",{id:id},"",1)
	newband:=settings.add2("rebar/band",{id:id,vis:1,width:200},"",1)
	tb:=new toolbar(1,hwnd(1),id)
	for a,b in rebar.keep
		b.add(xml.ea(newband),1)
}