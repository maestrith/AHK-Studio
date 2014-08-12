Github_Repository(){
	file:=ssn(current(1),"@file").text
	if !rep:=vversion.ssn("//*[@file='" file "']")
		rep:=vversion.Add({path:"info",att:{file:file},dup:1})
	repo:=ssn(rep,"@repo").text
	if !(repo){
		InputBox,repo,Please name this repo,Enter a name for this repo.
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
	InputBox,commitmsg,New Commit Message,Please enter a commit message for this commit
	if ErrorLevel
		return m("Commit message is required")
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