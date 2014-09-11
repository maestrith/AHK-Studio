current(parent=""){
	sc:=csc()
	node:=files.ssn("//*[@sc='" sc.2357 "']")
	if parent=1
		return node.ParentNode
	if parent=2
		return xml.ea(node.ParentNode)
	return node
}