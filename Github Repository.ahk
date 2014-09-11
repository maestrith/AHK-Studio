Github_Repository(){
	static
	verfile:=new versionkeep
	if !settings.ssn("//github")
		settings.Add({path:"github",att:{owner:"",email:"",name:"",token:""}})
	list:=sn(verfile.node,"versions/version"),info:=settings.ea("//github"),newwin:=new WindowTracker(25)
	newwin.add(["Text,,Use Ctrl+Up/Down to increment the version","TreeView,w300 h200 AltSubmit geditgr,,w","Text,,Version Number:","Edit,w300 ggrvn","Button,ggraddver -TabStop,Add Version","Text,,Commit Info:","Edit,w300 r5 -Wrap ggredit,,wh","Button,gcommit Default,Commit,y"])
	newwin.Show("Github Repository"),tv:=[],githubinfo:=TV_Add("Github Info"),hotkeys([25],{"^up":"grup","^down":"grdown"})
	change:={email:"Github Email",name:"Your Name (for commits)",owner:"Username for Github",token:"API Token for Github"}
	for a,b in info
		tv[TV_Add(change[a] " - " _:=a!="token"?b:RegExReplace(b,".","*"),githubinfo)]:={node:a,value:b}
	for a,b in StrSplit("owner,email,name,token",",")
		if !info[b]
			TV_Modify(githubinfo,"Expand")
	repo:=TV_Add("Repository Name: " ssn(verfile.node,"@repo").text)
	goto popver
	Return
	gredit:
	ControlGetText,version,Edit1,% hwnd([25])
	if !version
		return m("Please set the version number")
	ControlGetText,text,Edit2,% hwnd([25])
	if verfile.settext(version,text)
		goto popver
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
	Return
	grup:
	grdown:
	graddver:
	if (A_ThisLabel="graddver")
		ControlFocus,Edit1,% hwnd([25])
	start:=verfile.updown(25,"Edit1",A_ThisLabel)
	if !TV_Modify(vertv[start],"Select Vis Focus"){
		verfile.Add(start)
		goto popver
	}
	return
	grvn:
	ControlGetText,start,Edit1,% hwnd([25])
	Return
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
		ControlFocus,Edit2,% hwnd([25])
		ControlSend,Edit2,^{End},% hwnd([25])
		ControlSetText,Edit1,%vn%,% hwnd([25])
		lastversion:=vn
	}if (A_EventInfo=repo){
		ControlGet,hwnd,hwnd,,SysTreeView321,% hwnd([25])
		newrepo:=InputBox(hwnd,"Enter the new name for your repository","New Repository name",ssn(node,"@repo").text)
		TV_Modify(TV_GetSelection(),"","Repository Name: " newrepo),verfile.node.SetAttribute("repo",newrepo)
	}
	Return
	grc:
	ssn(verfile.node,"versions/version[@number='" lastversion "']").text:=newwin[].versioninfo
	Return
	commit:
	TV_GetText(version,TV_GetSelection())
	ControlGetText,cm,Edit2,% hwnd([25])
	if !(version&&cm)
		return m("Please set a version and create some information for that version.")
	ok:=commit(cm)
	ea:=settings.ea("//github")
	top:=vversion.ssn("//*[@file='" current(2).file "']"),node:=ssn(top,"versions/version[@number='" version "']")
	repo:=ssn(top,"@repo").text
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	if (release:=ssn(node,"@id").text){
		url:=github.url "/repos/" ea.owner "/" repo "/releases/" release "?access_token=" ea.token
		http.Open("DELETE",url),http.send(),node.removeattribute("id")
	}
	url:=github.url "/repos/" ea.owner "/" repo "/releases?access_token=" ea.token
	notes:=github.utf8(cm)
	json={"tag_name":"%version%","target_commitish":"master","name":"%version%","body":"%notes%","draft":false,"prerelease":false}
	http.Open("POST",url),http.send(json)
	info:=github.find("url",http.ResponseText)
	id:=RegExReplace(info,"(.*)\/")
	node.SetAttribute("id",id)
	return
}