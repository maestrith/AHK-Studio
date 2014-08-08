striperror(text,fn){
	for a,b in StrSplit(text,"`n"){
		if RegExMatch(b,"i)^Error in")
			filename:=StrSplit(b,Chr(34)).2
		if InStr(b,"error at line"){
			RegExMatch(b,"(\d+)",line),debug.disconnect()
			filename:=StrSplit(b,Chr(34)).2
		}
		/*
			if InStr(b,"error at line"){
				RegExMatch(b,"(\d+)",line),debug.disconnect()
				;RegExMatch(b,Chr(34) "(.*)" Chr(34),filename)
				file:=StrSplit(b,Chr(34)).2
				file:=file?file:v.debugfilename
				tv(tv:=files.ssn("//file[@file='" file "']/@tv").text)
				sleep,300
				sc:=csc()
				start:=sc.2128(line-1),end:=sc.2136(line-1)
				sc.2160(start,end)
				return
			}
		*/
		if InStr(b,"--->"){
			RegExMatch(b,"(\d+)",line),debug.disconnect()
			;m(b,line-1)
		}
	}
	filename:=filename?filename:fn
	return {file:filename,line:line-1}
}