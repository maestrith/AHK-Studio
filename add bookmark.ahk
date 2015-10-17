Add_Bookmark(line=""){
	sc:=csc(),line:=line?line:sc.2166(sc.2008),end:=sc.2136(line),start:=sc.2128(line),_:=start=end?(add:=3,space:=""):(add:=4,space:=" "),sc.2003(end,space Chr(59) "#[" (name:=SubStr(current(3).filename,1,-4)) "]"),sc.2160(end+add,end+add+StrPut(name,utf-8)-1)
}