omni_search(start=""){
	static newwin,select:=[],obj:=[],pre
	if hwnd(20)
		return
	newwin:=new windowtracker(20),code_explorer.scan(current())
	Gui,Margin,0,0
	WinGetPos,x,y,w,h,% hwnd([1])
	width:=w-50,newwin.Add(["Edit,goss w" width " vsearch," start,"ListView,w" width " r15 -hdr -Multi gosgo,Menu Command|Additional|1|2|Rating|index"])
	Gui,20:-Caption
	hotkeys([20],{up:"omniup",down:"omnidown","^Backspace":"deleteback",Enter:"osgo"}),newwin.Show("Omni-Search",Center(20))
	ControlSend,Edit1,^{End},% hwnd([20])
	bm:=bookmarks.sn("//mark")
	if top:=cexml.ssn("//bookmarks")
		top.ParentNode.RemoveChild(top)
	top:=cexml.Add({path:"bookmarks"})
	while,bb:=bm.item[A_Index-1],ea:=bookmarks.ea(bb)
		if !cexml.ssn("//bookmark/*[@file='" ssn(bb.ParentNode,"@file").text "']")
			cexml.under(top,"bookmark",{type:"bookmark",text:ea.name,line:ea.line,file:ssn(bb.ParentNode,"@file").text,order:"text,type,file",root:ssn(bb,"ancestor::main/@file").text})
	oss:
	break:=1
	SetTimer,omnisearch,-10
	return
	omnisearch:
	Gui,20:Default
	GuiControl,20:-Redraw,SysListView321
	search:=newwin[].search,Select:=[],LV_Delete(),pre:=SubStr(search,1,1)
	pre:=omni_search_class.prefix[pre]?pre:"",search:=pre?SubStr(search,2):search,sort:=[],stext:=[]
	if (search="?"){
		LV_Delete()
		for a,b in omni_search_class.prefix{
			info:=a="+"?"Add Function Call":b
			LV_Add("",a,info)
		}
		Loop,2
			LV_Modify(A_Index,"AutoHDR")
		GuiControl,20:+Redraw,SysListView321
		return
	}
	for a,b in StrSplit(search)
		stext[b]:=stext[b]=""?1:stext[b]+1
	find:=omni_search_class.prefix[pre]
	if(find="menu")
		find:="menu/item"
	else if(find!="file"&&find)
		find:="*[@type='" find "']"
	else if(find="file")
		find:="file"
	else if(find="")
		find:="*[@type]"
	list:=cexml.sn("//" find),break:=0,currentparent:=current(2).file
	while,ll:=list.Item[A_Index-1]{
		if(break){
			break:=0
			break
		}
		b:=xml.ea(ll),info:=StrSplit(b.order,","),rating:=0,text:=b[info.1]
		for c,d in stext{
			RegExReplace(text,"i)" c,"",count)
			if (d>count||count=0)
				Continue 2
			rating+=count
			if (count=d)
				rating+=10
		}
		if div:=RegExMatch(text,"i)" sea:=RegExReplace(search,"(.)","\b$1.*"),found){
			rating+=100/div
			for c,d in StrSplit(sea,"\b")
				rating+=20/RegExMatch(text,"i)\b" d)
		}
		if(ssn(ll,"ancestor::main[@file='" b.file "']")&&search="")
			rating+=100
		for c,d in StrSplit(search," ")
			if RegExMatch(text,"i)\b" d)
				rating+=20
		if(SubStr(text,1,StrLen(search))=search)
			rating+=50
		if(currentparent=ssn(ll,"ancestor::main/@file").text)
			rating+=30
		two:=info.2="type"&&v.options.Show_Type_Prefix?omni_search_class.iprefix[b[info.2]] "  " b[info.2]:b[info.2]
		item:=LV_Add("",b[info.1],two,b[info.3],b[info.4],rating,LV_GetCount()+1)
		Select[item]:=b
	}
	Loop,6
		LV_ModifyCol(A_Index,"Auto")
	for a,b in [5,6]
		LV_ModifyCol(b,0)
	LV_ModifyCol(5,"Logical SortDesc")
	LV_Modify(1,"Select Vis Focus")
	GuiControl,20:+Redraw,SysListView321
	return
	20GuiEscape:
	20GuiClose:
	hwnd({rem:20})
	return
	osgo:
	Gui,20:Default
	LV_GetText(num,LV_GetNext(),6),item:=Select[num],search:=newwin[].search,pre:=SubStr(search,1,1)
	if (type:=item.launch){
		text:=clean(item.text)
		if (type="label")
			SetTimer,%text%,-1
		else
			%text%()
		hwnd({rem:20})
	}else if(pre="+"){
		hwnd({rem:20}),args:=item.args,sc:=csc(),args:=RegExReplace(args,"U)=?" chr(34) "(.*)" chr(34)),build:=item.text "("
		for a,b in StrSplit(args,","){
			comma:=a_index>1?",":""
			value:=InputBox(sc.sc,"Add Function Call","Insert a value for : " b " :`n" item.text "(" item.args ")`n" build ")","")
			value:=value?value:Chr(34) Chr(34)
			build.=comma value
		}
		build.=")"
		sc.2003(sc.2008,build)
	}else if(item.type="bookmark"){
		tv(files.ssn("//main[@file='" item.root "']/descendant::file[@file='" item.file "']/@tv").text)
		Sleep,200
		sc:=csc(),sc.2024(sc.2166(item.pos)),hwnd({rem:20})
	}else if(item.type="file")
		hwnd({rem:20}),tv(files.ssn("//main[@file='" item.parent "']/descendant::file[@file='" item.file "']/@tv").text)
	else if(item.type~="i)(label|object|method|function|hotkey|class|property|variable)"){
		hwnd({rem:20}),TV(files.ssn("//*[@file='" item.file "']/@tv").text)
		Sleep,200
		item.text:=item.type="class"?"class " item.text:item.text
		csc().2160(item.pos,item.pos+StrPut(item.text,"Utf-8")-1),v.sc.2169,getpos(),v.sc.2400
	}
	return
	omniup:
	omnidown:
	return LV_Select(20,A_ThisLabel="omniup"?-1:1)
	deleteback:
	GuiControl,20:-Redraw,Edit1
	Send,+^{Left}{Backspace}
	GuiControl,20:+Redraw,Edit1
	return
}