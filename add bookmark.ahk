Add_Bookmark(line=""){
	sc:=csc(),file:=ssn(current(),"@file").text,line:=line?line:sc.2166(sc.2008),bookmark:=InputBox(sc.sc,"New Bookmark","Enter a name for this bookmark","")
	if !parent:=bookmarks.ssn("//main[@file='" current(2).file "']")
		parent:=bookmarks.Add({path:"main",att:{file:current(2).file},dup:1})
	if !node:=ssn(parent,"file[@file='" current(3).file "']")
		node:=bookmarks.under({under:parent,node:"file",att:{file:file}})
	if ssn(node,"mark[@name='" bookmark "']")
		return m("Bookmark " bookmark " already exists.  Please choose another name")
	bookmarks.under({under:node,node:"mark",att:{line:line,name:bookmark}}),sc.2043(line,4),code_explorer.scan(current())
}