Previous_Bookmark(){
	bm:=bookmarks.ssn("//file[@file='" current(3).file "']")
	m(bm.xml,current(2).file,bookmarks[])
}