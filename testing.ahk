testing(){
	return github_repository()
	ea:=settings.ea("//github")
	git:=new github("maestrith",ea.token)
	file:=ssn(current(1),"@file").text
	if !rep:=vversion.ssn("//*[@file='" file "']")
		rep:=vversion.Add({path:"info",att:{file:file},dup:1})
	repo:=ssn(rep,"@repo").text
	fn:=[]
	;fn["newwin.ahk"]:=1
	git.delete(repo,fn)
	return
	/*
	*/
	m(file)
	list:=""
	Loop,github\%repo%\*.ahk,0,1
	{
		ff:=A_LoopFileFullPath
		StringReplace,ff,ff,github\%repo%\
		list.=ff "`n"
	}
	m(list)
	;m("testing")
}