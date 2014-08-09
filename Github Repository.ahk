Github_Repository(){
	file:=ssn(current(1),"@file").text
	if !rep:=vversion.ssn("//*[@file='" file "']")
		rep:=vversion.Add({path:"info",att:{file:file},dup:1})
	repo:=ssn(rep,"@repo").text
	if !(repo){
		InputBox,repo,Please name this repo,Enter a name for this repo.
		repo:=RegExReplace(RegExReplace(repo," ","-"),"\W")
		if ErrorLevel
			return
		rep.SetAttribute("repo",repo)
	}
	ea:=settings.ea("//github")
	git:=new github(ea.owner,ea.token)
	InputBox,commitmsg,New Commit Message,Please enter a commit message for this commit
	if ErrorLevel
		return m("Commit message is required")
	current_commit:=git.getref(repo)
	if !(current_commit){
		git.CreateRepo(repo)
		git.CreateFile(repo,"README.md",";Readme.md","First Commit",name,email)
		Sleep,500
		current_commit:=git.getref(repo)
	}
	if !FileExist("github\" repo)
		FileCreateDir,github\%repo%
	uplist:=[],save(),cfiles:=sn(current(1),"file/@file")
	while,filename:=cfiles.item[A_Index-1].text{
		text:=update({get:filename})
		SplitPath,filename,file
		FileRead,compare,github\%repo%\%file%
		StringReplace,compare,compare,`r`n,`n,All
		if (text!=compare){
			FileDelete,github\%repo%\%file%
			FileAppend,%text%,github\%repo%\%file%,utf-8
			uplist[file]:=text
		}
	}
	filez:=[]
	for a,text in uplist{
		blob:=git.blob(repo,text)
		SplashTextOn,200,150,Updating,%a%
		filez[a]:=blob
	}
	tree:=git.Tree(repo,current_commit,filez)
	commit:=git.commit(repo,tree,current_commit,commitmsg,ea.name,ea.email)
	info:=git.ref(repo,commit)
	if info=200
		TrayTip,GitHub Update Complete,Updated files
	Else
		m("An Error Occured")
}