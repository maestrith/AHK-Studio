Class Code_Explorer{
	static explore:=[],TreeView:=[],sort:=[],function:="Om`n)^\s*((\w|[^\x00-\x7F])+)\((.*)?\)[\s+;.*\s+]?[\s*]?{",label:="Om`n)^\s*((\w|[^\x00-\x7F])+):[\s+;]",class:="Om`ni)^[\s*]?(class[\s*](\w|[^\x00-\x7F])+)",functions:=[],variables:=[],varlist:=[]
	scan(node){
		explore:=[],bits:=[],method:=[],filename:=ssn(node,"@file").text,parentfile:=ssn(node,"ancestor::main/@file").text
		if !main:=cexml.ssn("//main[@file='" parentfile "']")
			main:=cexml.Add2("main",{file:parentfile},"",1)
		SplitPath,filename,name,folder
		if !(folder)
			SplitPath,parentfile,,folder
		if !cce:=ssn(main,"file[@file='" filename "']")
			cce:=cexml.under(main,"file",{type:"File",parent:parentfile,file:filename,name:name,folder:folder,order:"name,type,folder"})
		else
			cce.ParentNode.RemoveChild(cce),cce:=cexml.under(main,"file",{type:"File",parent:parentfile,file:filename,name:name,folder:folder,order:"name,type,folder"})
		for a,b in ["class","file","function","hotkey","label","menu","method","property","variable"]
			explore[b]:=[]
		skip:=ssn(node,"@skip").text?1:0,code:=update({get:filename}),pos:=1
		if pos:=InStr(code,"/*"){
			while,pos:=RegExMatch(code,"UOms`n)^\s*?(\/\*.*\*\/)",found,pos){
				rep:=RegExReplace(found.1,"(:|\(|\))","_")
				StringReplace,code,code,% found.1,%rep%,All
				pos:=found.Pos(1)+StrLen(found.1)
			}
		}
		if !v.options.Disable_Variable_List{
			pos:=1,this.variables[parentfile,filename]:=[]
			while,pos:=RegExMatch(code,"Osm`n)(\w*)(\s*)?:=",var,pos){
				if var.len(1){
					if !ssn(main,"descendant::*[@type='variable'][@text='" var.1 "']")
						cexml.under(cce,"info",{type:"Variable",file:filename,pos:pos-1,text:var.1,root:parentfile,upper:upper(var.1),order:"text,type,file"})
					pos:=var.Pos(1)+var.len(1)
				}else{
					pos:=1
					break
				}
			}
		}
		for type,find in {Hotkey:"Om`n)^\s*([#|!|^|\+|~|\$|&|<|>|*]*?\w+)::",Label:this.label}{
			pos:=1
			while,pos:=RegExMatch(code,find,fun,pos)
				ppos:=fun.Pos(1)-1,pos1:=ppos?StrPut(SubStr(code,1,ppos),"utf-8")-1:0,cexml.under(cce,"info",{type:type,file:filename,pos:pos1,text:fun.1,root:parentfile,upper:upper(fun.1),order:"text,type,file"}),pos:=fun.pos(1)+1
		}
		lastpos:=pos:=1,pos:=1,objects:=[]
		while,pos:=RegExMatch(code,code_explorer.class,found,pos){
			ppos:=found.Pos(1)-1,pos1:=ppos?StrPut(SubStr(code,1,ppos),"utf-8")-1:0
			start:=found.Pos(1)
			ncode:=SubStr(code,found.pos(1)),add:=start:=braces:=0,nnc:=StrSplit(ncode,"`n")
			for a,line in nnc{
				add+=StrPut(line,"utf-8")
				line:=Trim(RegExReplace(line,"(\s+" Chr(59) ".*)"))
				if(SubStr(line,0,1)="{")
					braces++,start:=1
				if(SubStr(line,1,1)="}"){
					while,((found1:=SubStr(line,A_Index,1))~="(}|\s)"){
						if(found1~="\s")
							Continue
						braces--
					}
				}
				if(start&&braces=0)
					break
			}
			cexml.under(cce,"info",{type:"Class",file:filename,start:start,pos:pos1,end:pos1+add-1,text:SubStr(found.1,7),upper:upper(SubStr(found.1,7)),root:parentfile,order:"text,type,root"})
			pos:=found.Pos(1)+StrLen(found.1)
		}
		classlist:=sn(cce,"*[@type='Class']")
		for a,b in {Method:code_explorer.function,Property:"Om`n)^\s*((\w|[^\x00-\x7F])+)\[(.*)?\][\s+;.*\s+]?[\s*]?{"}{
			pos:=1
			while,pos:=RegExMatch(code,b,found,pos){
				if(found.1="if"){
					pos:=found.Pos(1)+StrLen(found.1)
					Continue
				}
				while,cl:=classlist.item[A_Index-1],ea:=xml.ea(cl){
					if(pos>ea.start&&pos<ea.end){
						cexml.under(cl,"info",{type:a,file:filename,pos:StrPut(SubStr(code,1,found.pos(1)-2),"utf-8"),text:found.1,upper:upper(found.1),args:found.value(3),class:ea.text,root:parentfile,order:"text,type,file,args"})
						pos:=found.Pos(1)+StrLen(found.1)
						Continue,2
					}
				}
				ppos:=found.Pos(1)-1,pos1:=ppos?StrPut(SubStr(code,1,ppos),"utf-8")-1:0
				cexml.under(cce,"info",{type:"Function",file:filename,opos:found.Pos(1),pos:pos1,text:found.1,upper:upper(found.1),args:found.value(3),class:found.1,root:parentfile,order:"text,type,file,args"})
				pos:=found.Pos(1)+StrLen(found.1)
			}
		}
		pos:=0
		while,pos:=RegExMatch(code,"OUi).*(\w*)\s*:=\s*new\s*(\w*)\(",found,++pos){
			npos:=StrPut(SubStr(code,1,found.Pos(1)-2),"utf-8")
			cexml.under(cce,"info",{type:"Instance",file:filename,upper:upper(found.1),pos:npos,text:found.1,root:parentfile,class:found.2,order:"text,type,class,root"})
			pos:=found.Pos(2)+found.len(2)
		}
		pos:=0
		while,pos:=RegExMatch(code,"OU);#\[(.*)\]",found,++pos){
			npos:=StrPut(SubStr(code,1,pos),"utf-8")
			cexml.under(cce,"info",{type:"Bookmark",file:filename,upper:upper(ea.name),pos:npos,text:found.1,root:parentfile,order:"text,type,root"})
			pos:=found.Pos(1)+found.len(1)
		}
		ubp(csc(),filename),pos:=fun.Pos(1)+len,this.explore[parentfile,filename]:=explore,this.skip[filename]:=skip
	}
	remove(filename){
		this.explore.remove(ssn(filename,"@file").text),list:=sn(filename,"@file")
		while,ll:=list.item[A_Index-1]
			this.explore.Remove(ll.text)
	}
	populate(){
		code_explorer.Refresh_Code_Explorer()
		Gui,1:TreeView,SysTreeView321
	}
	Add(value,parent=0,options=""){
		Gui,1:Default
		Gui,1:TreeView,SysTreeView322
		return this.Add(value,parent,options)
	}
	Refresh_Code_Explorer(){
		if v.options.Hide_Code_Explorer
			return
		Gui,1:Default
		Gui,1:TreeView,SysTreeView322
		TV_Delete()
		code_explorer.scan(current()),cet:=code_explorer.treeview:=new xml("TreeView"),bookmark:=[]
		SplashTextOff
		GuiControl,1:-Redraw,SysTreeView322
		fz:=cexml.sn("//main")
		while,fn:=fz.Item[A_Index-1]{
			things:=sn(fn,"descendant::*"),filename:=ssn(fn,"@file").text
			SplitPath,filename,file
			Gui,1:Default
			Gui,1:TreeView,SysTreeView322
			main:=TV_Add(file)
			while,tt:=things.Item[A_Index-1],ea:=xml.ea(tt){
				if(ea.type="variable"||tt.nodename="file")
					continue
				if !top:=cet.ssn("//main[@file='" filename "'][@type='" ea.type "']")
					if !(ea.type~="(Method|Property)")
						top:=cet.Add2("main",{file:filename,type:ea.type,tv:TV_Add(ea.type,main,"Vis Sort")},"",1)
				text:=ea[StrSplit(ea.order,",").1]
				if(ea.type~="(Method|Property)")
					cet.under(last,"info",{text:text,pos:ea.pos,file:ea.file,type:ea.type,tv:TV_Add(text,ssn(last,"@tv").text,"Sort")})
				else
					last:=cet.under(top,"info",{text:text,pos:ea.pos,file:ea.file,line:ea.line,type:ea.type,tv:TV_Add(text,ssn(top,"@tv").text,"Sort")})
			}
		}
		GuiControl,1:+Redraw,SysTreeView322
		return
		GuiContextMenu:
		MouseClick,Left
		ControlGetFocus,Focus,% hwnd([1])
		if(Focus="SysTreeView322"){
			GuiControl,+g,SysTreeView322
			code_explorer.Refresh_Code_Explorer()
			GuiControl,+gcej,SysTreeView322
		}
		if(Focus="SysTreeView321"){
			for a,b in StrSplit("Close,Open,Remove Segment,,Copy File Path,Copy Folder Path",",")
				Menu,rcm,Add,%b%,rcm
			Menu,rcm,show
			Menu,rcm,DeleteAll
			return
			rcm:
			if(A_ThisMenuItem~="(Close|Open)")
				%A_ThisMenuItem%()
			else if(A_ThisMenuItem~="Copy (File|Folder) Path"){
				pFile:=current(3).file
				SplitPath, pFile,,pFolder
				Clipboard:=InStr(A_ThisMenuItem,"Folder")?pFolder:pFile
			}else if(A_ThisMenuItem="Remove Segment")
				Remove_Segment()
			else
				m("Coming Soon....maybe")
			return
			rcmnew:
			new()
			return
		}
		return
	}
	cej(){
		cej:
		if (A_GuiEvent="S"&&A_GuiEvent!="RightClick"){
			list:=""
			code_explorer.TreeView.Transform()
			if found:=code_explorer.TreeView.ssn("//*[@tv='" A_EventInfo "']"){
				ea:=xml.ea(found)
				if(ea.pos="")
					return
				parent:=ssn(found,"ancestor::main/@file").text,TV(files.ssn("//main[@file='" parent "']/descendant::file[@file='" ea.file "']/@tv").text)
				Sleep,200
				if (ea.type="bookmark"){
					sc:=csc(),sc.2024(sc.2166(ea.pos))
					ControlFocus,,% "ahk_id" csc().sc
				}
				else
					csc().2160(ea.pos,ea.pos+StrPut(ea.text,"Utf-8")-1+_:=ea.type="class"?+6:+0),v.sc.2169,v.sc.2400
			}
			return
		}
		return
	}
}