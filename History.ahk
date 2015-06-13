History(file=""){
	static history:=[],yrotsih:=[],current:=1,stop:=0,lastfile
	if(file.back)
		return current:=current-1>0?current-1:current,hh:=history[current],tv:=files.ssn("//main[@file='" hh.parent "']/descendant::file[@file='" hh.file "']/@tv").text,tv(tv)
	if(file.forward)
		return current:=current+1>history.MaxIndex()?current:current+1,hh:=history[current],tv:=files.ssn("//main[@file='" hh.parent "']/descendant::file[@file='" hh.file "']/@tv").text,tv(tv)
	if(yrotsih[file])
		return current:=yrotsih[file]
	history.Insert({parent:current(2).file,file:file}),yrotsih[file]:=history.MaxIndex(),current:=history.MaxIndex()
	return
}