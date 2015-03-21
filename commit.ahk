commit(commitmsg,version){
	if !commitmsg
		return m("Please Select a commit message from the list of versions, or enter a commit message in the space provided")
	ea:=settings.ea("//github")
	if !(ea.name&&ea.email&&ea.token&&ea.owner)
		return update_github_info()
	file:=ssn(current(1),"@file").text
	if !rep:=vversion.ssn("//*[@file='" file "']")
		rep:=vversion.Add({path:"info",att:{file:file},dup:1})
	repo:=ssn(rep,"@repo").text
	if !(repo)
		return m("Please setup a repo name in the GUI by clicking Repository Name:")
	delete:=[],main:=ssn(current(1),"@file").text
	SplitPath,main,,dir
	node:=vversion.sn("//info[@file='" current(2).file "']/files/file")
	while,nn:=node.item[A_Index-1].text{
		StringReplace,file,nn,%dir%\
		current[file]:=1
	}
	replace:="github\" repo "\"
	main:=files.ssn("//main[@file='" current(2).file "']"),verfiles:=vversion.ssn("//info[@file='" current(2).file "']")
	Loop,github\%repo%\*.*,0,1
	{
		if !A_LoopFileExt
			Continue
		StringReplace,file,A_LoopFileFullPath,%replace%
		if !(ssn(main,"descendant::file[@filename='" file "']")){
			vf:=sn(verfiles,"files/*")
			while,vv:=vf.Item[A_Index-1]
				if InStr(vv.text,file)
					Continue,2
			Delete[file]:=1,del:=1
		}
	}
	git:=new github()
	if del
		git.Delete(repo,delete)
	current_commit:=git.getref(repo)
	if !(current_commit){
		git.CreateRepo(repo)
		git.CreateFile(repo,"README.md",";Readme.md","First Commit",ea.name,ea.email)
		Sleep,500
		current_commit:=git.getref(repo)
	}
	if !FileExist("github\" repo)
		FileCreateDir,github\%repo%
	uplist:=[],save(),filelist:=sn(current(1),"descendant::file/@file"),safe:=[]
	while,ff:=filelist.item[A_Index-1].text{
		SplitPath,ff,file,dir
		if A_Index=1
			dircheck:=dir,newfile:=file
		StringReplace,newdir,dir,%dircheck%,,All
		localdir:="github\" repo newdir
		if !FileExist(localdir)
			FileCreateDir,%localdir%
		FileRead,compare,%localdir%\%file%
		FileRead,text,%ff%
		if (text!=compare||(InStr(text,Chr(59) "github_version")&&ssn(rep,"versions/version[@number='" version "']/@id").text="")){
			StringReplace,gitdir,newdir,\,/,All
			uplist[Trim(gitdir "/" file,"/")]:=text,up:=1,safe[localdir "\" file]:=ff
		}
	}
	node:=vversion.sn("//info[@file='" current(2).file "']/files/file")
	mainfolder:=current(2).file
	SplitPath,mainfolder,,checkdir
	while,nn:=node.item[A_Index-1].text{
		FileRead,orig,%nn%
		StringReplace,newfn,nn,%checkdir%\
		StringReplace,gitfile,newfn,\,/,All
		safefile:=localdir "\" newfn
		FileRead,local,%safefile%
		if (local!=orig)
			uplist[gitfile]:=orig,safe[safefile]:=nn,up:=1
	}
	if !up
		return m("Nothing new to upload")
	upload:=[]
	for a,text in uplist{
		blob:=git.blob(repo,RegExReplace(text,Chr(59) "github_version",version))
		SplashTextOn,200,100,Updating,%a%
		upload[a]:=blob
	}
	tree:=git.Tree(repo,current_commit,upload)
	commit:=git.commit(repo,tree,current_commit,commitmsg,ea.name,ea.email)
	/*
		clipboard:=commit
		59ce5e25eb395465aeec39b6ac7586ab16fc9b98
	*/
	info:=git.ref(repo,commit)
	if (info=200){
		TrayTip,GitHub Update Complete,Updated files
		for a,b in safe{
			SplitPath,a,,dir
			if !FileExist(dir)
				FileCreateDir,%dir%
			FileCopy,%b%,%a%,1
		}
		return 1
	}
	Else
		m("An Error Occured",commit)
}