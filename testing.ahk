testing(){
	main:=current(2).file
	node:=vversion.ssn("//info[@file='" main "']")
	fs:=ssn(node,"files")
	m(fs.xml)
	;m("testing")
}