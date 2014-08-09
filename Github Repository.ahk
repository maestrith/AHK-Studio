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
		filez[a]:=blob
	}
	tree:=git.Tree(repo,current_commit,filez)
	
	commit:=git.commit(repo,tree,current_commit,commitmsg,ea.name,ea.email)
	
	git.ref(repo,commit) ;new commit value
	return
	/*
		for a,b in {owner:"Enter the username associated with your account",name:"Enter the name you want associated with your commits",email:"Enter the e-mail address associated with your commits"}{
			if !info:=settings.ssn("//github/@" a).text{
				InputBox,info,Required Information,%b%
				if ErrorLevel
					return m("All information is required. Please try again")
			}
			newinfo:=1
			gitinfo[a]:=info
		}
		if newinfo
			settings.Add({path:"github",att:gitinfo})
		git:=new github(gitinfo.owner)
		if !FileExist("github")
			FileCreateDir,github
		file:=ssn(current(1),"@file").text
		if !rep:=vversion.ssn("//*[@file='" file "']")
			rep:=vversion.Add({path:"info",att:{file:file},dup:1})
		repo:=ssn(rep,"@repo").text
		if !(repo){
			InputBox,repo,Please name this repo,Enter a name for this repo.
			if ErrorLevel
				return
			compile:=1
			if name:=git.CreateRepo(repo)
				rep.SetAttribute("repo",name)
			Else
				return m("An error occured")
			repo:=name
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
				uplist[file]:=text,ask:=1
			}
		}
		if ask
			InputBox,comment,Information Required,Please enter your commit information
		for filename,text in uplist{
			info:="Updating file " filename
			SplashTextOn,400,150,Updating Files,%info%
			IniRead,file,github\%repo%.ini,%filename%,sha,0
			if !(file){
				comment:=comment?comment:"First Commit"
				git.CreateFile(repo,filename,text,comment,gitinfo.name,gitinfo.email)
			}Else{
				comment:=comment?comment:"Updating info"
				git.update(repo,filename,text,comment)
			}
		}
		if compile
			git.tree(repo,gitinfo.name,gitinfo.email)
		SplashTextOff
	*/
}