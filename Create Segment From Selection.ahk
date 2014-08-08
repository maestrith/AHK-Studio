Create_Segment_From_Selection(){
	pos:=posinfo(),sc:=csc()
	if (pos.start=pos.end)
		return m("Please select some text to create a new segment from")
	else{
		InputBox,newsegment,Please Name Your New Segment,Please enter a name for your new segment
		if ErrorLevel
			return
		filename:=ssn(current(1),"@file").text,newsegment:=InStr(newsegment,".ahk")?newsegment:newsegment ".ahk"
		SplitPath,filename,,dir
		if FileExist(dir "\" newsegment)
			return m("Segment name already exists. Please choose another")
		clip:=Clipboard
		sc.2177
		new_segment(dir "\" newsegment,clipboard)
		clipboard:=clip
	}
}