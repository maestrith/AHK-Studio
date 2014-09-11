class omni_search_class{
	static prefix:={"@":"menu","^":"file",":":"label","(":"function","{":"class","[":"method","&":"hotkey","+":"function","#":"bookmark"}
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
		fl:=files.sn("//file")
		while,ff:=fl.item[A_Index-1]{
			file:=ssn(ff,"@file").text
			SplitPath,file,fn,dir
			list.Insert({root:ssn(ff.parentnode,"@file").text,filename:file,dir:dir,name:fn,type:"file",order:"name,dir"})
		}
		list.bookmarks:=[]
		for a,b in code_explorer.bookmarks
			for c,d in b
				list.Insert(d)
		for a,b in code_explorer.explore
			for q,r in b
				for c,d in r
					for e,f in d
						list.Insert(f)
		list.fun:=[]
		for a,b in code_explorer.functions[current(2).file]
			list.fun[a]:=b
		return list
	}
}