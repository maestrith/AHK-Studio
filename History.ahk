History(file=""){
	static history:=[],current:=0,stop:=0,lastfile
	if (file.stop=0||file.stop=1)
		return stop:=file.stop
	if !file
		return {history:history,current:current}
	if file.current
		return current:=file.current
	if (stop=0&&file&&lastfile!=file)
		history.Insert(file),current:=history.MaxIndex(),lastfile:=file
}