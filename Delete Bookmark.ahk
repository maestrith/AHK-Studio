Delete_Bookmark(line:=""){
	sc:=csc(),line:=line?line:sc.2166(sc.2008),text:=Trim(sc.getline(line)),start:=sc.2128(line),pos:=RegExMatch(text,"UO)(\s*" Chr(59) "#\[.*\])",found),sc.2190(start+pos-1),sc.2192(start+pos-1+found.len(1)),sc.2194(0,""),code_explorer.scan(current())
}