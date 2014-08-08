testing(){
	git:=new github("maestrith")
	if !FileExist("github")
		FileCreateDir,github
	if !rep:=vversion.ssn("//*[@file='" file:=ssn(current(1),"@file").text "']")
		rep:=vversion.Add({path:"info",att:{file:file}})
	repo:=ssn(rep,"@repo").text
	if !(repo){
		InputBox,repo,Please name this repo,Enter a name for this repo.
		if ErrorLevel
			return
		if name:=git.CreateRepo(repo)
			rep.SetAttribute("repo",name)
		Else
			return m("An error occured")
	}Else{
		filename:=ssn(current(),"@file").text
		text:=update({get:filename})
		IniRead,file,github\%repo%.ini,%filename%,sha,0
		if !(file){
			git.CreateFile(repo,filename,text,"First Commit","Chad Wilson","maestrith@gmail.com")
		}Else{
			git.update(repo,filename,text,"Working on the class")
		}
	}
}