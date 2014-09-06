class omni_search_class{
	static prefix:={"@":"menu","^":"file",":":"label","(":"function","{":"class","[":"method","&":"hotkey","+":"function"}
	__New(){
		this.menus()
		return this
	}
	menus(){
		this.menulist:=[]
		list:=menus.sn("//@clean")
		while,mm:=list.item[A_Index-1]{
			clean:=RegExReplace(mm.text,"_"," "),hotkey:=convert_hotkey(menus.ssn("//*[@clean='" mm.text "']/@hotkey").text)
			if IsFunc(mm.text)
				this.menulist.menu[mm.text]:={launch:"func",name:clean,text:mm.text,type:"menu",sort:mm.text,additional1:hotkey,order:"name,additional1"}
			if IsLabel(mm.text)
				this.menulist.menu[mm.text]:={launch:"label",name:clean,text:mm.text,type:"menu",sort:mm.text,additional1:hotkey,order:"name,additional1"}
		}
	}
	search(){
		list:=this.menulist.menu.clone()
		fl:=files.sn("//file/@file")
		while,ff:=fl.item[A_Index-1].text{
			SplitPath,ff,fn,dir
			list.Insert({filename:ff,dir:dir,name:fn,type:"file",order:"name,dir"})
		}
		if !(prefix~="(\+|@|\^)"){
			for a,b in code_explorer.explore
				for c,d in b
					for e,f in d
						list.Insert(f)
		}
		return list
	}
}