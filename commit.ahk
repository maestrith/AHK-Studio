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
	SplitPath,main,upfn,dir
	node:=vversion.sn("//info[@file='" current(2).file "']/files/file"),current:=[]
	while,nn:=node.item[A_Index-1].text{
		StringReplace,file,nn,%dir%\
		current[file]:=1
	}
	replace:="github\" repo "\",main:=files.ssn("//main[@file='" current(2).file "']"),verfiles:=vversion.ssn("//info[@file='" current(2).file "']"),vf:=sn(verfiles,"files/*"),git:=new github()
	Loop,github\%repo%\*.*,0,1
	{
		if(A_LoopFileExt=""||A_LoopFileExt="json")
			Continue
		StringReplace,file,A_LoopFileFullPath,%replace%
		if (ssn(main,"descendant::file[@github='" file "']").xml=""){
			while,vv:=vf.Item[A_Index-1]
				if InStr(vv.text,file)
					Continue,2
			Delete[file]:=1,del:=1
		}
	}
	if del
		git.Delete(repo,delete)
	current_commit:=git.getref(repo)
	if(!current_commit){
		git.CreateRepo(repo)
		Sleep,500
		current_commit:=git.getref(repo)
	}
	if !FileExist("github\" repo)
		FileCreateDir,github\%repo%
	filelist:=sn(current(1),"descendant::file[@github!='']"),safe:=[],uplist:=[],save(),all:=update("get").1,localdir:="github\" repo "\"
	fileinfo:=xml.ea(vversion.ssn("//*[@file='" current(2).file "']"))
	if(fileinfo.onefile){
		filetext:=publish(1)
		openfile:=FileOpen("github\" repo "\" current(2).file,"rw","utf-8"),currenttext:=openfile.Read(openfile.length)
		if(filetext!=openfile)
			uplist[upfn]:={text:filetext,local:localdir upfn,encoding:"utf-8"},up:=1
	}else{
		while,fl:=filelist.item[A_Index-1],fea:=xml.ea(fl),ff:=fea.file,gf:=fea.github{
			text:=All[ff]
			if(fl.haschildnodes()){
				check:=sn(fl,"descendant::*")
				while,ch:=check.item[A_Index-1],eaa:=xml.ea(ch){
					if(eaa.github!=eaa.filename)
						StringReplace,text,text,% eaa.include,% Chr(35) "Include " eaa.github
				} 
			}
			SplitPath,gf,fn,dir
			local:=localdir _:=dir?dir "\" fn:fn
			if !FileExist(localdir)
				FileCreateDir,%localdir%
			FileRead,compare,%local%
			text:=RegExReplace(text,"\R","`r`n")
			if(compare!=text)
				uplist[RegExReplace(gf,"\\","/")]:={text:text,local:local,encoding:fea.encoding},up:=1
	}}
	node:=vversion.sn("//info[@file='" current(2).file "']/files/file"),mainfolder:=current(2).file
	SplitPath,mainfolder,,checkdir
	if !up
		return m("Nothing new to upload")
	upload:=[]
	for a,text in uplist{
		blob:=git.blob(repo,RegExReplace(text.text,Chr(59) "github_version",version))
		if(!blob){
			SplashTextOff
			elist.=text.local " - " git.oops "`n"
			;return m("Error occured while uploading " text.local)
		}
		SplashTextOn,200,100,Updating,%a%
		upload[a]:=blob
	}
	tree:=git.Tree(repo,current_commit,upload),commit:=git.commit(repo,tree,current_commit,commitmsg,ea.name,ea.email),info:=git.ref(repo,commit)
	if(info=200){
		TrayTip,GitHub Update Complete,Updated files
		for a,b in uplist{
			local:=b.local,text:=b.text,encoding:=b.encoding
			SplitPath,local,,dir
			if(!FileExist(dir))
				FileCreateDir,%dir%
			FileDelete,%local%
			FileAppend,%text%,%local%,%encoding%
		}
		if(elist)
			m(clipboard:=elist)
		return 1
	}
	Else{
		if(elist)
			m(elist)
		m("An Error Occured",commit)
	}
}