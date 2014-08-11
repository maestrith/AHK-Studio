testing(){
	ea:=settings.ea("//github")
	git:=new github("maestrith",ea.token)
	fn:=[]
	fn["newwin.ahk"]:=1
	git.delete("AHK-Studio",fn)
	;m("testing")
}