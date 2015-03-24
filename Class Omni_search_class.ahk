class omni_search_class{
	static prefix:={"@":"Menu","^":"File",":":"Label","(":"Function","{":"Class","[":"Method","&":"Hotkey","+":"Function","#":"Bookmark",".":"Property","%":"Variable","<":"Object"}
	static iprefix:={Menu:"@",File:"^",Label:":",Function:"(",Class:"{",Method:"[",Hotkey:"&",Bookmark:"#",Property:".",Variable:"%",Object:"<"}
	__New(){
		this.menus()
		return this
	}
	menus(){
		this.menulist:=[],list:=menus.sn("//menu"),top:=cexml.Add2("menu")
		while,mm:=list.item[A_Index-1],ea:=xml.ea(mm){
			clean:=ea.clean,hotkey:=convert_hotkey(ea.hotkey)
			StringReplace,clean,clean,_,%A_Space%,all
			launch:=IsFunc(ea.clean)?"func":IsLabel(ea.clean)?"label":""
			if !launch
				Continue
			cexml.under(top,"item",{launch:launch,text:clean,type:"Menu",sort:clean,additional1:hotkey,order:"text,type,additional1"})
		}
	}
}