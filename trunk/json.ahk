json(info,filename){
	if !RegExReplace(info,"\s"){
		info="%filename%":{"content":";blank file"}
		return info
	}
	if InStr(info,Chr(59) "auto_version")
		info:=RegExReplace(info,Chr(59) "auto_version","Version=" newver)
	for a,b in [["\","\\"],[Chr(34),"\" Chr(34)],["`n","\n"],["`t","\t"],["`r",""]]
		StringReplace,info,info,% b.1,% b.2,All
	next="%filename%":{"content":"%info%"}
	return next
}