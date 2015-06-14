History(file=""){
	static history:=[],current:=1,stop:=0,lastfile ;,yrotsih:=[]
	;t(history.MaxIndex(),current,history[current].file)
	if(file.back)
		return current:=current-1>0?current-1:current,hh:=history[current],tv:=files.ssn("//main[@file='" hh.parent "']/descendant::file[@file='" hh.file "']/@tv").text,tv(tv,"",1)
	if(file.forward)
		return current:=current+1>history.MaxIndex()?current:current+1,hh:=history[current],tv:=files.ssn("//main[@file='" hh.parent "']/descendant::file[@file='" hh.file "']/@tv").text,tv(tv,"",1)
	;t(history.MaxIndex()-current,history.MaxIndex(),"Work on this")
	history.RemoveAt(current+1,history.MaxIndex()-current)
	history.Insert({parent:current(2).file,file:file})
	;m(history.MaxIndex(),file)
	;yrotsih[file]:=history.MaxIndex()
	current:=history.MaxIndex()
	return
}