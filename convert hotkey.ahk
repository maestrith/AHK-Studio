convert_hotkey(key){
	StringUpper,key,key
	if(InStr(key,"^v"))
		return
	for a,b in [{Shift:"+"},{Win:"#"},{Ctrl:"^"},{Alt:"!"}]
		for c,d in b
			key:=RegExReplace(key,"\" d,c "+")
	return key
}