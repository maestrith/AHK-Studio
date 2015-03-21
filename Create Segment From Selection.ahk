Create_Segment_From_Selection(){
	pos:=posinfo(),sc:=csc()
	if (pos.start=pos.end)
		return m("Please select some text to create a new segment from")
	else{
		text:=sc.getseltext(),RegExMatch(text,"^(\w+)",segment)
		filename:=ssn(current(1),"@file").text
		SplitPath,filename,,dir
		FileSelectFile,newsegment,,%dir%\%segment1%
		newsegment:=InStr(newsegment,".ahk")?newsegment:newsegment ".ahk"
		if ErrorLevel
			return
		if FileExist(newsegment)
			return m("Segment name already exists. Please choose another")
		clip:=Clipboard
		sc.2177
		new_segment(newsegment,clipboard)
		clipboard:=clip
	}
}