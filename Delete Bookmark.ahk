Delete_Bookmark(line=""){
	sc:=csc(),line:=line?line:sc.2166(sc.2008),file:=current(3).file
	sc.2044(line,4),rem:=bookmarks.ssn("//file[@file='" file "']/mark[@line='" line "']"),parent:=rem.ParentNode,rem.ParentNode.RemoveChild(rem)
	if !parent.firstchild
		parent.ParentNode.RemoveChild(parent)
	code_explorer.scan(current())
}