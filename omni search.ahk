omni_search(start=""){
	if hwnd(20)
		return
	static menulist:=[],searchin,rated
	code_explorer.scan(current())
	Setup(20),hotkeys([20],{up:"omniup",down:"omnidown"})
	Gui,Margin,0,0
	list:=menus.sn("//@clean")
	menulist:=[]
	for a,b in ["menu","file","label","method","function","hotkey","class"]
		menulist[b]:=[]
	while,mm:=list.item[A_Index-1]{
		clean:=RegExReplace(mm.text,"_"," ")
		hotkey:=convert_hotkey(menus.ssn("//*[@clean='" mm.text "']/@hotkey").text)
		if IsFunc(mm.text)
			menulist.menu[mm.text]:={launch:"func",name:clean,text:mm.text,type:"menu",sort:mm.text,additional1:hotkey}
		if IsLabel(mm.text)
			menulist.menu[mm.text]:={launch:"label",name:clean,text:mm.text,type:"menu",sort:mm.text,additional1:hotkey}
	}
	for a,b in code_explorer.explore
		for c,f in b
			for _,d in f
			{
				file:=d.root
				SplitPath,file,filename
				additional:={label:["Label:",filename],hotkey:["Hotkey::",filename],function:[d.text "(" d.args ")",filename],class:["Class{",filename],method:["Class " d.class,d.text "(" d.args ")",filename]}
				menulist[c].Insert({type:c,file:d.file,pos:d.pos,text:d.text,name:d.text,additional1:additional[c].1,additional2:additional[c].2,additional3:additional[c].3,sort:d.text})
			}
	for filename in v.filelist{
		SplitPath,filename,file,outdir
		menulist.file[A_Index]:={filename:filename,additional1:outdir,name:file,type:"file",sort:filename}
	}
	Gui,-Caption
	WinGetPos,x,y,w,h,% hwnd([1])
	width:=w-100
	Gui,Add,Edit,w%width% gsortmenu,%start%
	Gui,Add,ListView,w%width% h200 -hdr -Multi gmsgo,Menu Command|Additional|1|2|Rating|index
	Gui,Add,Button,Default gmsgo w500 Hide,Execute Command
	Gui,Show,% Center(20),Omni-Search
	ControlSend,Edit1,^{End},% hwnd([20])
	hotkeys([20],{"^Backspace":"deleteback"})
	goto sortmenu
	return
	deleteback:
	GuiControl,20:-Redraw,Edit1
	Send,+^{Left}{Backspace}
	GuiControl,20:+Redraw,Edit1
	return
	sortmenu:
	Gui,20:Default
	GuiControl,20:-Redraw,SysListView321
	LV_Delete()
	ControlGetText,find,Edit1,% hwnd([20])
	search:=[],searchin:=""
	prefix:={"@":"menu","^":"file",":":"label","(":"function","{":"class","[":"method","&":"hotkey"}
	if searchin:=prefix[SubStr(find,1,1)]
		find:=SubStr(find,2)
	for a,b in StrSplit(find)
		search[b]:=!search[b]?1:search[b]+=1
	fff:=RegExReplace(find,"(.)","$1|"),rated:=[],ffff:=[]
	if searchin
		ffff:=[menulist[searchin]]
	Else
		for a,b in menulist
			ffff.Insert(b)
	ssss:="i)" Trim(RegExReplace(find,"(.)","$1.+ "))
	for q,b in ffff{
		for a,r in b{
			rating:=0
			for c,d in search{
				RegExReplace(r.name,"i)" c,"",count)
				if (count<d)
					continue 2
				if count
					rating+=count
				if (count=d)
					rating+=10
			}
			for index,word in StrSplit(find," ")
				if InStr(r.name,word)
					rating+=40
			rating+=InStr("abcdefghijklmnopqrstuvwxyz",SubStr(r.name,1,1))
			if RegExMatch(r.name,"i)^" find)
				rating+=200
			if (find=""&&files.ssn("//main[@file='" r.filename "']"))
				rating+=100
			if (SubStr(find,1,1)=SubStr(r.name,1,1))
				rating+=30
			if RegExMatch(r.name,ssss)
				rating+=100
			rated.Insert({rating:rating,value:r.name,additional1:r.additional1,additional2:r.additional2,additional3:r.additional3,obj:r})
		}
	}
	for a,b in rated
		LV_Add("",b.value,b.additional1,b.additional2,b.additional3,b.rating,A_Index)
	Loop,4
		LV_ModifyCol(A_Index,"AutoHDR")
	for a,b in [5,6]
		LV_ModifyCol(b,0)
	LV_ModifyCol(1,"Sort Logical"),LV_ModifyCol(5,"SortDesc Logical"),LV_Modify(1,"Select Vis Focus")
	GuiControl,20:+Redraw,SysListView321
	Return
	omniup:
	omnidown:
	return lv_select(20,A_ThisLabel="omniup"?-1:1)
	return
	msgo:
	LV_GetText(menu,LV_GetNext(),6)
	ob:=rated[menu].obj
	if (ob.type="file")
		TV(files.ssn("//*[@file='" ob.filename "']/@tv").text)
	if (ob.type="menu"){
		if (ob.text="omni_search")
			goto omniend
		menu:=ob.text
		if (ob.launch="label"){
			SetTimer,%menu%,10
			Sleep,11
			SetTimer,%menu%,Off
		}else
		%menu%()
	}
	if RegExMatch(ob.type,"i)(label|method|function|hotkey|class)"){
		TV(files.ssn("//*[@file='" ob.file "']/@tv").text)
		Sleep,200
		csc().2160(ob.pos,ob.pos+StrLen(ob.text)),v.sc.2169,getpos(),v.sc.2400
	}
	omniend:
	hwnd({rem:20})
	return
}