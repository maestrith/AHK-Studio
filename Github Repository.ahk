Github_Repository(){
	static
	verfile:=new versionkeep
	if !settings.ssn("//github")
		settings.Add({path:"github",att:{owner:"",email:"",name:"",token:""}})
	list:=sn(verfile.node,"versions/version"),info:=settings.ea("//github"),setup(25),newwin:=new WindowTracker(25)
	newwin.add(["TreeView,w200 h200 AltSubmit geditgr,,w","Text,,Version Number:","Edit,w200 ggrvn","Button,ggraddver -TabStop,Add Version","Text,,Version Info:","Edit,w200 r5 -Wrap,,wh","Button,gcommit Default,Commit,y"])
	newwin.Show("Github"),tv:=[],githubinfo:=TV_Add("Github Info"),hotkeys([25],{up:"grup",down:"grdown"})
	change:={email:"Github Email",name:"Your Name (for commits)",owner:"Username for Github",token:"API Token for Github"}
	for a,b in info
		tv[TV_Add(change[a] " - " _:=a!="token"?b:RegExReplace(b,".","*"),githubinfo)]:={node:a,value:b}
	for a,b in StrSplit("owner,email,name,token",",")
		if !info[b]
			TV_Modify(githubinfo,"Expand")
	repo:=TV_Add("Repository Name: " ssn(verfile.node,"@repo").text)
	goto popver
	Return
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
	/*
		if sel:=vertv[start]
			TV_Modify(sel,"Select Vis Focus")
		else{
			GuiControl,25:-Redraw,SysTreeView321			
			ControlGetText,vers,Edit1,% hwnd([25])
			
			
			
			TV_Modify(TV_GetChild(0),"Select"),TV_Delete(ver),ver:=TV_Add("Versions"),vertv:=[],node:=vversion.ssn("//info[@file='" ssn(current(1),"@file").text "']"),list:=sn(node,"versions/version")
			while,ll:=list.item[A_Index-1]
				vertv[ssn(ll,"@number").text]:=TV_Add(ssn(ll,"@number").text,ver)
			TV_Modify(TV_GetChild(ver),"Select Vis Focus")
			GuiControl,25:+Redraw,SysTreeView321
		}
	*/
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
	ControlGetText,cm,Edit2,% hwnd([25])
	commit(cm)
	return
}
commit(commitmsg){
	if !commitmsg
		return m("Please Select a commit message")
	file:=ssn(current(1),"@file").text
	if !rep:=vversion.ssn("//*[@file='" file "']")
		rep:=vversion.Add({path:"info",att:{file:file},dup:1})
	repo:=ssn(rep,"@repo").text
	if !(repo){
		repo:=InputBox(csc().sc,"Please name this repo","Enter a name for this repo.")
		repo:=RegExReplace(repo," ","-")
		if ErrorLevel
			return
		rep.SetAttribute("repo",repo)
	}
	delete:=[],current:=[]
	main:=ssn(current(1),"@file").text
	SplitPath,main,,dir
	fl:=sn(current(1),"file/@file")
	while,ff:=fl.item[A_Index-1].Text{
		StringReplace,file,ff,%dir%\
		current[file]:=1
	}
	replace:="github\" repo "\"
	Loop,github\%repo%\*.*,0,1
	{
		if !A_LoopFileExt
			Continue
		StringReplace,file,A_LoopFileFullPath,%replace%
		if !current[file]
			Delete[file]:=1,del:=1
	}
	ea:=settings.ea("//github")
	if !(ea.name&&ea.email&&ea.token&&ea.owner)
		return update_github_info()
	git:=new github(ea.owner,ea.token)
	if del
		git.Delete(repo,delete)
	/*
		commitmsg:=InputBox(csc().sc,"New Commit Message","Please enter a commit message for this commit","")
		if ErrorLevel
			return m("Commit message is required")
	*/
	current_commit:=git.getref(repo)
	if !(current_commit){
		git.CreateRepo(repo)
		git.CreateFile(repo,"README.md",";Readme.md","First Commit",ea.name,ea.email)
		Sleep,500
		current_commit:=git.getref(repo)
	}
	if !FileExist("github\" repo)
		FileCreateDir,github\%repo%
	uplist:=[],save(),filelist:=sn(current(1),"file/@file")
	while,ff:=filelist.item[A_Index-1].text{
		SplitPath,ff,file,dir
		if A_Index=1
			dircheck:=dir,newfile:=file
		text:=update({get:ff})
		StringReplace,newdir,dir,%dircheck%,,All
		localdir:="github\" repo newdir
		if !FileExist(localdir)
			FileCreateDir,%localdir%
		FileRead,compare,%localdir%\%file%
		StringReplace,compare,compare,`r`n,`n,All
		if (text!=compare){
			FileDelete,%localdir%\%file%
			FileAppend,%text%,%localdir%\%file%,utf-8
			StringReplace,gitdir,newdir,\,/,All
			uplist[Trim(gitdir "/" file,"/")]:=text,up:=1
		}
	}
	if !up
		return m("Nothing new to upload")
	upload:=[]
	for a,text in uplist{
		blob:=git.blob(repo,text)
		SplashTextOn,200,150,Updating,%a%
		upload[a]:=blob
	}
	tree:=git.Tree(repo,current_commit,upload)
	commit:=git.commit(repo,tree,current_commit,commitmsg,ea.name,ea.email)
	info:=git.ref(repo,commit)
	if info=200
		TrayTip,GitHub Update Complete,Updated files
	Else
		m("An Error Occured")
}