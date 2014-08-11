striperror(text,fn){
	for a,b in StrSplit(text,"`n"){
		if RegExMatch(b,"i)^Error in")
			filename:=StrSplit(b,Chr(34)).2
		if InStr(b,"error at line"){
			RegExMatch(b,"(\d+)",line),debug.disconnect()
			filename:=StrSplit(b,Chr(34)).2
		}
		if InStr(b,"--->")
			RegExMatch(b,"(\d+)",line),debug.disconnect()
	}
	filename:=filename?filename:fn
	return {file:filename,line:line-1}
}