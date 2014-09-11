add_bookmark(){
	sc:=csc()
	file:=ssn(current(),"@file").text
	line:=sc.2166(sc.2008)
	bookmark:=InputBox(sc.sc,"New Bookmark","Enter a name for this bookmark","")
	if !node:=bookmarks.ssn("//file[@file='" file "']")
		node:=bookmarks.Add({path:"file",att:{file:file},dup:1})
	bookmarks.under({under:node,node:"mark",att:{line:line,name:bookmark}})
	sc.2043(line,4)
}