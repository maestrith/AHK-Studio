Github_Repository(){
	static
	verfile:=new versionkeep,addfile:=[]
	if !settings.ssn("//github")
		settings.Add({path:"github",att:{owner:"",email:"",name:"",token:""}})
	list:=sn(verfile.node,"versions/version"),info:=settings.ea("//github"),newwin:=new WindowTracker(25)
	newwin.add(["Text,,Use Ctrl+Up/Down to increment the version","TreeView,w300 h200 AltSubmit geditgr,,w","Text,,Version Number:","Edit,w300 ggrvn vversion","Button,ggraddver -TabStop,Add Version","Button,x+10 ggraddfile -TabStop,Add Files (text based only)","Text,xm,Commit Info:","Edit,w300 r5 -Wrap ggredit vcm,,wh","Radio,vpre Checked,Pre-Release,y","Radio,vdraft,Draft,y","Radio,vfull,Full Release,y","Button,gcommit Default,Commit,y","Button,x+10 gchangerelease,Change Release Status,y"])
	newwin.Show("Github Repository"),tv:=[],githubinfo:=TV_Add("Github Info"),hotkeys([25],{"^up":"grup","^down":"grdown",Delete:"grdelete",BS:"grdelete"})
	change:={email:"Github Email",name:"Your Name (for commits)",owner:"Username for Github",token:"API Token for Github"}
	for a,b in info
		tv[TV_Add(change[a] " - " _:=a!="token"?b:RegExReplace(b,".","*"),githubinfo)]:={node:a,value:b}
	for a,b in StrSplit("owner,email,name,token",",")
		if !info[b]
			TV_Modify(githubinfo,"Expand")
	repo:=TV_Add("Repository Name: " ssn(verfile.node,"@repo").text),fn:=sn(verfile.node,"files/file"),addfiles:=TV_Add("Additional Files")
	while,ff:=fn.item[A_Index-1]
		addfile[TV_Add(ff.text,addfiles)]:=ff
	goto,popver
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
	FileSelectFile,file,,%dir%,Select A File to Add To This Repo Upload,*.ahk;*.xml
	if ErrorLevel
		return
	node:=vversion.ssn("//info[@file='" main "']")
	if !extra:=ssn(node,"files")
		extra:=vversion.under(node,"files")
	if !ssn(extra,"file[text()='" file "']")
		tv[TV_Add(file,addfiles,"Vis")]:=vversion.under(extra,"file","",file)
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
	grup:
	grdown:
	graddver:
	if (A_ThisLabel="graddver")
		ControlFocus,Edit1,% hwnd([25])
	start:=verfile.updown(25,"Edit1",A_ThisLabel)
	if !TV_Modify(vertv[start],"Select Vis Focus"){
		verfile.Add(start)
		goto,popver
	}
	return
	grvn:
	ControlGetText,start,Edit1,% hwnd([25])
	return
	editgr:
	TV_GetText(parent,TV_GetParent(TV_GetSelection()))
	if (parent="versions"){
		TV_GetText(vn,TV_GetSelection())
		ControlSetText,Edit1,%vn%,% hwnd([25])
		text:=verfile.getver(vn)
		ControlSetText,Edit2,% RegExReplace(text,"\n","`r`n") _:=text?"`r`n":""
	}
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
		json={"tag_name":"%version%","target_commitish":"master","name":"%version%","body":"%body%","draft":%draft%,"prerelease":%pre%}
		http.open("PATCH",url),http.Send(json)
	}else m("No record of this version being uploaded")
		return
	commit:
	info:=newwin[]
	draft:=info.draft?"true":"false",pre:=info.pre?"true":"false"
	ControlGetText,version,Edit1,% hwnd([25])
	ControlGetText,cm,Edit2,% hwnd([25])
	if !(version&&cm)
		return m("Please set a version and create some information for that version.")
	ok:=commit(cm,version)
	ea:=settings.ea("//github"),top:=vversion.ssn("//*[@file='" current(2).file "']"),node:=ssn(top,"versions/version[@number='" version "']"),repo:=ssn(top,"@repo").text
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	if proxy:=settings.ssn("//proxy").text
		http.setProxy(2,proxy)
	if (release:=ssn(node,"@id").text){
		url:=github.url "/repos/" ea.owner "/" repo "/releases/" release "?access_token=" ea.token,body:=github.utf8(cm)
		json={"tag_name":"%version%","target_commitish":"master","name":"%version%","body":"%body%","draft":%draft%,"prerelease":%pre%}
		http.open("PATCH",url),http.Send(json)
	}else{
		url:=github.url "/repos/" ea.owner "/" repo "/releases?access_token=" ea.token
		notes:=github.utf8(cm)
		json={"tag_name":"%version%","target_commitish":"master","name":"%version%","body":"%notes%","draft":%draft%,"prerelease":%pre%}
		http.Open("POST",url),http.send(json)
		info:=github.find("url",http.ResponseText)
		id:=RegExReplace(info,"(.*)\/")
		node.SetAttribute("id",id)
	}
	vversion.save(1)
	return
}