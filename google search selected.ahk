google_search_selected(){
	sc:=csc(),text:=RegExReplace(sc.getseltext()," ","+")
	if !text
		return m("Select some text to search")
	string:="http://www.google.com/search?q=" text
	Run,%string%
}