current(parent=""){
	sc:=csc()
	node:=files.ssn("//*[@sc='" sc.2357 "']")
	if parent
		return node.parentnode
	return node
}