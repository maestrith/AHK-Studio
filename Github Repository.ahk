Github_Repository(){
	static
	addfile:=[],git:=new github()
	newwin:=new windowtracker(25),verfile:=new versionkeep(newwin)
	newwin.add(["ListView,w140 h200 geditgr AltSubmit NoSortHdr,Github Setting|Value,wy","ListView,x+5 w215 h200,Additional Files|Directory,xy","Button,xm gGRUpdate,&Update Release Info,y","Button,x+5 gcommit,&Commit,y","Button,x+5 ggraddfile Default,&Add Text Files,y"])
	newwin.show("Github")
	if !settings.ssn("//github")
		settings.Add({path:"github",att:{owner:"",email:"",name:"",token:""}})
	list:=sn(verfile.node,"versions/version"),tv:=[]
	Gui,25:Default
	Gui,25:ListView,SysListView321
	change:={email:"Github Email",name:"Your Name (for commits)",owner:"Username for Github",token:"API Token for Github"}
	for a,b in change
		change[b]:=a
	Gosub,grpop
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	ControlFocus,Edit1,% hwnd([25])
	Send,^{End}
	SetTimer,relstatus,-10
	return
	grpop:
	Gui,25:Default
	Gui,25:ListView,SysListView321
	info:=settings.ea("//github"),LV_Delete()
	for a,b in info
		LV_Add("",change[a],_:=a!="token"?b:RegExReplace(b,".","*"))
	LV_Add("","Repository Name",ssn(verfile.node,"@repo").text)
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	v.releasestatus:=LV_Add("","Release Status")
	Gui,25:ListView,SysListView322
	fn:=sn(verfile.node,"files/file"),LV_Delete()
	while,ff:=fn.item[A_Index-1].text{
		SplitPath,ff,file,dd
		LV_Add("",file,dd "\")
	}
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	return
	grdelete:
	Gui,25:Default
	ControlGetFocus,focus,% hwnd([25])
	if (focus="SysTreeView321"){
		node:=addfile[TV_GetSelection()]
		node.ParentNode.RemoveChild(node)
		TV_Delete(TV_GetSelection())
	}else
		ControlSend,%focus%,{%A_ThisHotkey%},% hwnd([25])
	return
	graddfile:
	Gui,25:Default
	main:=current(2).file
	SplitPath,main,,dir
	FileSelectFile,file,M,%dir%,Select A File to Add To This Repo Upload,*.ahk;*.xml
	if ErrorLevel
		return
	node:=vversion.ssn("//info[@file='" main "']")
	if !extra:=ssn(node,"files")
		extra:=vversion.under(node,"files")
	for a,b in StrSplit(file,"`n","`n"){
		if(A_Index=1)
			start:=b
		else if !ssn(extra,"file[text()='" start "\" b "']")
			vversion.under(extra,"file","",start "\" b)
	}
	goto,grpop
	return
	gredit:
	ControlGetText,version,Edit1,% hwnd([25])
	if !version
		return m("Please set the version number")
	ControlGetText,text,Edit2,% hwnd([25])
	if verfile.settext(version,text)
		goto,popver
	return
	popver:
	GuiControl,25:-Redraw,SysTreeView321
	ControlGetText,versel,Edit1,% hwnd([25])
	if ver
		TV_Delete(ver),TV_Modify(TV_GetChild(0))
	ver:=TV_Add("Versions"),vertv:=[],list:=sn(verfile.node,"versions/version")
	while,ll:=list.item[A_Index-1]
		vertv[ssn(ll,"@number").text]:=TV_Add(ssn(ll,"@number").text,ver)
	TV_Modify(TV_GetChild(ver),"Select Vis Focus")
	GuiControl,25:+Redraw,SysTreeView321
	return
	editgr:
	Gui,25:Default
	Gui,25:ListView,SysListView321
	if(LV_GetNext()=0||A_GuiEvent!="Normal")
		return
	LV_GetText(value,LV_GetNext())
	GuiControlGet,hwnd,25:hwnd,SysListView321
	if(node:=settings.ssn("//github/@" change[value])){
		new:=InputBox(hwnd,value,"New Value For " value,node.text)
		if(ErrorLevel)
			return
		node.text:=new
	}else if(value="Repository Name"){
		node:=ssn(verfile.node,"@repo"),new:=InputBox(hwnd,"Repository Name","New Value For The Repository Name",node.text)
		if(ErrorLevel)
			return
		node.text:=new
	}else if(value="Release Status"){
		m("Make a popup window with 3 choices, Draft, Pre-Release, Full Release")
	}
	goto,grpop
	return
	GRUpdate:
	info:=git.send("get",git.url "/repos/" git.owner "/" git.repo "/releases" git.token),pos:=1
	while,RegExMatch(info,"Oi)\x22id\x22",found,Pos){
		out:=[]
		for a,b in {id:"\d*",prerelease:"\w*",draft:"\w*"}{
			RegExMatch(info,"Oi)\x22" a "\x22:(" b ")",found,pos)
			out[a]:=found.1
			RegExMatch(info,"OUi)\x22tag_name\x22:\x22(.*)\x22",found,pos)
			out["tag_name"]:=found.1
			pos++
		}
		pos:=RegExMatch(info,"Oi)\x22upload_url\x22",found,pos)
		if(out.tag_name)
			if node:=ssn(verfile.node,"descendant::*[@number='" out.tag_name "']")
				for a,b in {draft:out.draft,pre:out.prerelease,id:out.id}
					node.SetAttribute(a,b)
	}
	SetTimer,relstatus,-10
	return
	Gui,25:Default
	Gui,TreeView,SysTreeView322
	TV_GetText(parent,TV_GetParent(TV_GetSelection()))
	if vv:=tv[A_EventInfo]{
		ControlGet,hwnd,hwnd,,SysTreeView321,% hwnd([25])
		newinfo:=InputBox(hwnd,change[vv.node],"Please enter a new value for " change[vv.node],vv.value)
		settings.ssn("//github").SetAttribute(vv.node,newinfo)
		TV_Modify(TV_GetSelection(),"",change[vv.node] " - " newinfo)
	}else if versioninfo:=ssn(verfile.node,"versions/version[@number='" vn "']"){
		ControlSetText,Edit2,% RegExReplace(versioninfo.text,"\n","`r`n") _:=versioninfo.text?"`r`n":"",% hwnd([25])
		if !addfile[TV_GetSelection()]
			ControlFocus,Edit2,% hwnd([25])
		ControlSend,Edit2,^{End},% hwnd([25])
		ControlSetText,Edit1,%vn%,% hwnd([25])
		lastversion:=vn
	}if (A_EventInfo=repo){
		ControlGet,hwnd,hwnd,,SysTreeView321,% hwnd([25])
		newrepo:=InputBox(hwnd,"Enter the new name for your repository","New Repository name",ssn(verfile.node,"@repo").text),newrepo:=RegExReplace(newrepo," ","-")
		TV_Modify(TV_GetSelection(),"","Repository Name: " newrepo),verfile.node.SetAttribute("repo",newrepo)
	}
	return
	/*
		Todo:
		-Make a commit button
		if no commit made
			auto do commit
		else
			set it to full release
		-Have a tag somewhere that denotes the release type (full,pre)
		
		Give the buttons & like &Commit
		;releases:
		;GET /repos/:owner/:repo/releases
		;m(git.send("get",git.url "/repos/maestrith/AHK-Studio/releases" git.token))
		;GET /repos/:owner/:repo/releases/:id
		;m(git.send("get",git.url "/repos/maestrith/AHK-Studio/releases/1383395" git.token))
		;GET /repos/:owner/:repo/releases/tags/:tag
		info:=git.send("get",git.url "/repos/maestrith/AHK-Studio/releases/tags/1.1.2" git.token)
		RegExMatch(info,"i)\x22id\x22:(\d*)",id)
		m(id1,id,info)
	*/
	grc:
	ssn(verfile.node,"versions/version[@number='" lastversion "']").text:=newwin[].versioninfo
	return
	changerelease:
	info:=newwin[],cm:=info.cm,version:=info.version,ea:=settings.ea("//github"),top:=vversion.ssn("//*[@file='" current(2).file "']"),node:=ssn(top,"versions/version[@number='" version "']"),repo:=ssn(top,"@repo").text
	draft:=info.draft?"true":"false",pre:=info.pre?"true":"false"
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	if proxy:=settings.ssn("//proxy").text
		http.setProxy(2,proxy)
	if (release:=ssn(node,"@id").text){
		url:=github.url "/repos/" ea.owner "/" repo "/releases/" release "?access_token=" ea.token,body:=github.utf8(cm)
		json={"tag_name":"%version%","target_commitish":"master","name":"%version%","body":"%body%","draft":%draft%,"pre":%pre%}
		http.open("PATCH",url),http.Send(json)
	}else m("No record of this version being uploaded")
		return
	commit:
	info:=newwin[]
	Gui,25:Default
	TV_GetText(version,TV_GetSelection())
	Gui,25:ListView,SysListView321
	LV_GetText(status,v.releasestatus,2)
	;return m(info.cm,version,status)
	draft:=status="draft"?"true":"false",pre:=status~="i)Unknown|Pre-Release"?"true":"false"
	cm:=info.cm
	;node:=
	;return m(node.xml)
	;draft:=info.draft?"true":"false",pre:=info.pre?"true":"false"
	;ControlGetText,version,Edit1,% hwnd([25])
	;ControlGetText,cm,Edit2,% hwnd([25])
	if !(version&&cm)
		return m("Please set a version and create some information for that version.")
	
	ok:=commit(cm,version)
	
	
	ea:=settings.ea("//github")
	top:=vversion.ssn("//*[@file='" current(2).file "']")
	node:=ssn(top,"versions/version[@number='" version "']")
	repo:=ssn(top,"@repo").text
	
	
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	if proxy:=settings.ssn("//proxy").text
		http.setProxy(2,proxy)
	if(release:=ssn(node,"@id").text){
		url:=github.url "/repos/" ea.owner "/" repo "/releases/" release "?access_token=" ea.token,body:=github.utf8(cm)
		json={"tag_name":"%version%","target_commitish":"master","name":"%version%","body":"%body%","draft":%draft%,"pre":%pre%}
		http.open("PATCH",url),clipboard:=http.Send(json)
		m(clipboard)
	}else{
		url:=github.url "/repos/" ea.owner "/" repo "/releases?access_token=" ea.token
		notes:=github.utf8(cm)
		json={"tag_name":"%version%","target_commitish":"master","name":"%version%","body":"%notes%","draft":%draft%,"pre":%pre%}
		http.Open("POST",url),http.send(json)
		info:=github.find("url",http.ResponseText)
		clipboard:=info
		id:=RegExReplace(info,"(.*)\/")
		node.SetAttribute("id",id)
		m(info)
	}
	vversion.save(1)
	return
}