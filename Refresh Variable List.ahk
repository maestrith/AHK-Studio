Refresh_Variable_List(){
	code_explorer.scan(current()),code_explorer.varlist:=[]
	for a,b in code_explorer.variables
		for c,d in b
			for e in d
				if !RegExMatch(code_explorer.varlist[a],"\b" e "\b")
					code_explorer.varlist[a].=" " e
}