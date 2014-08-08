class code_explorer{
	static explore:=[],TreeView:=[],sort:=[]
	scan(node){
		explore:=[]
		for a,b in ["menu","file","label","method","function","hotkey","class"]
			explore[b]:=[]
		filename:=ssn(node,"@file").text,parentfile:=ssn(node.ParentNode,"@file").text
		code:=update({get:filename}),pos:=1
		for type,find in {hotkey:"Om`n)^\s*([#|!|^|\+|~|\$|&|<|>|*]*?\w+)::",label:"Om`n)^\s*(\w*):[\s+;]"}{
			pos:=1
			while,pos:=RegExMatch(code,find,fun,pos){
				explore[type].Insert({type:type,file:filename,pos:fun.Pos(1)-1,text:fun.value(1),root:parentfile})
				len:=fun.len(1)?fun.len(1):1
				pos:=fun.Pos(1)+len
			}
		}
		pos:=1
		Loop
		{
			fpos:=[]
			for type,find in {class:"^\s*class[\s*]((\w+))",function:"\s*((\w|[^\x00-\x7F])+)\((.*)?\)[\s*;.*\s*]?\s*{"}{
				if pp:=RegExMatch(code,"Oim`n)" find,fun,pos)
					fpos[fun.Pos(1)]:={type:type,fun:fun,pos:fun.Pos(1),args:fun.value(3)}
			}
			if !fpos.minindex()
				break
			findit:=SubStr(code,fpos[fpos.minindex()].pos)
			left:="",count:=0,foundone:=0
			for a,b in StrSplit(findit,"`n"){
				orig:=b,left.=orig "`n"
				b:=RegExReplace(b,"i)(\s+" Chr(59) ".*)"),b:=RegExReplace(b,"U)(" Chr(34) ".*" Chr(34) ")","_")
				RegExReplace(b,"{","",open),count+=open
				if open
					foundone:=1
				RegExReplace(b,"}","",close),count-=close
				if (count=0&&foundone)
					break
			}
			type:=fpos[fpos.MinIndex()].type,treeview:=fpos[fpos.MinIndex()].fun.value(1)
			if (treeview!=lastfun)
				explore[type].insert({file:filename,pos:fpos.MinIndex()-1,text:treeview,args:fpos[fpos.MinIndex()].args,root:parentfile})
			if (fpos[fpos.minindex()].type="class"){
				pp:=1
				while,pp:=RegExMatch(left,"Om`n)^\s*((\w|[^\x00-\x7F])+)\((.*)?\)[\s+;.*\s+]?[\s*]?{",method,pp){
					explore.Method.Insert({file:filename,pos:method.Pos(1)+fpos.minindex()-2,text:method.value(1),args:method.value(3),class:TreeView,root:parentfile})
					pp:=method.Pos(1)+1
				}
			}
			pos:=fpos.MinIndex()+StrLen(left)
			lastfun:=TreeView
		}
		this.explore[filename]:=explore
		for a,b in ["Hotkey","Label","Function","Class","Method"]
			this.sort[parentfile,b]:=explore[b]
	}
	remove(filename){
		this.explore.remove(ssn(filename,"@file").text)
		list:=sn(filename,"@file")
		while,ll:=list.item[A_Index-1]
			this.explore.Remove(ll.text)
	}
	populate(){
		code_explorer.Refresh_Code_Explorer()
		Gui,1:TreeView,SysTreeView321
	}
	cej(){
		cej:
		if (A_GuiEvent="S"&&A_GuiEvent!="RightClick"){
			list:=""
			obj:=code_explorer.TreeView.obj[A_EventInfo]
			if (obj.file){
				TV(files.ssn("//*[@file='" obj.file "']/@tv").text)
				Sleep,200
				csc().2160(obj.pos,obj.pos+StrLen(obj.text)),v.sc.2169,v.sc.2400
			}
		}
		return
	}
	Refresh_Code_Explorer(){
		if v.options.Hide_Code_Explorer
			return
		Gui,1:TreeView,SysTreeView322
		GuiControl,1:-Redraw,SysTreeView322
		code_explorer.scan(current())
		TV_Delete(),this.treeview:=[],roots:=[]
		this.TreeView.filename:=[],this.TreeView.type:=[],this.TreeView.class:=[],this.TreeView.obj:=[]
		for a,b in code_explorer.explore
			for c,f in b
				for _,d in f
				{
					file:=d.root
					SplitPath,file,filename
					if !this.TreeView.filename[filename]
						this.TreeView.filename[filename]:=TV_Add(filename)
					if (c!="method")
						if !item:=this.TreeView.type[filename,c]
							item:=this.TreeView.type[filename,c]:=TV_Add(c,this.TreeView.filename[filename])
						if (c="method")
							this.treeview.obj[TV_Add(d.text,this.TreeView.class[filename,d.class],"Sort")]:=d
						Else if (c="class")
						{
						if !this.TreeView.class[filename,d.text]
							this.TreeView.obj[this.TreeView.class[filename,d.text]:=TV_Add(d.text,item,"Sort")]:=d
						}
					else if (c!="method")
						this.TreeView.obj[TV_Add(d.text,item,"Sort")]:=d
				}
		GuiControl,1:+Redraw,SysTreeView322
		return
		GuiContextMenu:
		ControlGetFocus,Focus,% hwnd([1])
		if (Focus="SysTreeView322")
			code_explorer.Refresh_Code_Explorer()
		if (Focus="SysTreeView321")
			new()
		return
	}
}