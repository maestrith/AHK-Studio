Github_Repository(){
	static
	addfile:=[],git:=new github()
	newwin:=new windowtracker(25),verfile:=new versionkeep(newwin)
	newwin.add(["ListView,w140 h200 geditgr AltSubmit NoSortHdr,Github Setting|Value,wy","ListView,x+5 w215 h200,Additional Files|Directory,xy","Button,xm gGRUpdate,&Update Release Info,y","Button,x+5 gcommit,&Commit,y","Button,xm ggrdelrep,Delete Repository,y","Button,x+5 ggraddfile Default,&Add Text Files,y"])
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
	TV_GetText(version,TV_GetSelection())
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
		new:=InputBox(hwnd,"Repository Name","New Value For The Repository Name",xml.ea(verfile.node).repo)
		if(ErrorLevel)
			return
		versionkeep.last.node:=vversion.ssn("//info[@file='" ssn(current(1),"@file").text "']")
		versionkeep.last.node.SetAttribute("repo",RegExReplace(new," ","-"))
		url:=git.url "/repos/" git.owner "/" new "/commits" git.token
		m(clipboard:=git.send("get",git.url "/repos/" git.owner "/" new "/git/trees/" git.sha(git.send("GET",url)) "?recursive=1" git.tok))
	}else if(value="Release Status"){
		Gui,25:Default
		Gui,25:ListView,SysListView321
		LV_GetText(current,v.releasestatus,2)
		setup(32)
		for a,b in ["Full Release","Pre-Release","Draft"]
			Gui,Add,Radio,% _:=b=current?"Checked":"",%b%
		Gui,Add,Button,gchangerelease Default,Submit
		Gui,Show
		return
		32GuiEscape:
		32GuiClose:
		hwnd({rem:32})
		WinActivate,% hwnd([25])
		return
		changerelease:
		Loop,3
		{
			ControlGet,sel,checked,,Button%A_Index%,% hwnd([32])
			ControlGetText,value,Button%A_Index%,% hwnd([32])
			if(sel)
				break
		}
		hwnd({rem:32})
		WinActivate,% hwnd([25])
		Gui,25:Default
		TV_GetText(version,TV_GetSelection()),info:=newwin[],cm:=info.cm,ea:=settings.ea("//github"),top:=vversion.ssn("//*[@file='" current(2).file "']"),node:=ssn(top,"versions/version[@number='" version "']"),repo:=ssn(top,"@repo").text,draft:=value="draft"?"true":"false",pre:=value="pre-release"?"true":"false"
		http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
		if proxy:=settings.ssn("//proxy").text
			http.setProxy(2,proxy)
		if(release:=ssn(node,"@id").text){
			url:=github.url "/repos/" ea.owner "/" repo "/releases/" release "?access_token=" ea.token,body:=github.utf8(cm)
			json={"tag_name":"%version%","target_commitish":"master","name":"%version%","body":"%body%","draft":%draft%,"prerelease":%pre%}
			http.open("PATCH",url),http.Send(json),GRUpdate({info:http.ResponseText})
		}else
			return m("No record of this version being uploaded")
		return
	}
	goto,grpop
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
	grdelrep:
	MsgBox,276,Delete This Repository,THIS CAN NOT BE UNDONE! ARE YOU SURE
	IfMsgBox,Yes
	{
		ea:=xml.ea(verfile.node)
		if(ea.repo="AHK-Studio")
			return m("NO! you can not.")
		info:=git.send("DELETE",git.url "/repos/" git.owner "/" ea.repo git.token)
		if(InStr(git.http.status,204)){
			rem:=vversion.ssn("//info[@file='" ssn(current(1),"@file").text "']"),rem.ParentNode.RemoveChild(rem)
			FileRemoveDir,% A_ScriptDir "\github\" ea.repo,1
		}else
			m("Something went wrong","Please make sure that you have a repository named " ea.repo " on the Gethub servers")
		goto,grpop
	}
	return
	grc:
	ssn(verfile.node,"versions/version[@number='" lastversion "']").text:=newwin[].versioninfo
	return
	commit:
	info:=newwin[]
	Gui,25:Default
	TV_GetText(version,TV_GetSelection())
	Gui,25:ListView,SysListView321
	LV_GetText(status,v.releasestatus,2)
	draft:=status="draft"?"true":"false",pre:=status~="i)Unknown|Pre-Release"?"true":"false"
	cm:=info.cm
	if !(version&&cm)
		return m("Please set a version and create some information for that version.")
	ok:=commit(cm,version),ea:=settings.ea("//github"),top:=vversion.ssn("//*[@file='" current(2).file "']"),node:=ssn(top,"versions/version[@number='" version "']"),repo:=ssn(top,"@repo").text,http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	if proxy:=settings.ssn("//proxy").text
		http.setProxy(2,proxy)
	if(release:=ssn(node,"@id").text){
		url:=github.url "/repos/" ea.owner "/" repo "/releases/" release "?access_token=" ea.token,body:=github.utf8(cm)
		json={"tag_name":"%version%","target_commitish":"master","name":"%version%","body":"%body%","draft":%draft%,"prerelease":%pre%}
		http.open("PATCH",url),http.Send(json)
	}else{
		url:=github.url "/repos/" ea.owner "/" repo "/releases?access_token=" ea.token,notes:=github.utf8(cm)
		json={"tag_name":"%version%","target_commitish":"master","name":"%version%","body":"%notes%","draft":%draft%,"prerelease":%pre%}
		http.Open("POST",url),http.send(json),info:=github.find("url",http.ResponseText),id:=RegExReplace(info,"(.*)\/"),node.SetAttribute("id",id)
	}
	GRUpdate({url:git.url "/repos/" git.owner "/" git.repo "/releases/" ssn(verfile.node,"descendant::*[@number='" version "']/@id").text git.token})
	vversion.save(1)
	return
}