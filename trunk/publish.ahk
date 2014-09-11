publish(return=""){
	sc:=csc(),text:=update("get").1,save()
	mainfile:=ssn(current(1),"@file").text
	publish:=update({get:mainfile})
	includes:=sn(current(1),"*/@include/..")
	while,ii:=includes.item[A_Index-1]
		if InStr(publish,ssn(ii,"@include").text)
			StringReplace,publish,publish,% ssn(ii,"@include").text,% update({get:ssn(ii,"@file").text}),All
	ea:=xml.ea(vversion.ssn("//*[@file='" ssn(current(1),"@file").text "']"))
	newver:=ea.version "." ea.increment
	if InStr(publish,Chr(59) "auto_version")
		publish:=RegExReplace(publish,Chr(59) "auto_version",newver)
	aa:=vversion.ea("//info[@file='" ssn(current(1),"@file").text "']")
	repver:=aa.versstyle?newver:"Version=" newver
	if InStr(publish,Chr(59) "auto_version")
		publish:=RegExReplace(publish,Chr(59) "auto_version",repver)
	if return
		return publish
	StringReplace,publish,publish,`n,`r`n,All
	Clipboard:=publish
	MsgBox,,AHK Studio,Project compiled and coppied to your clipboard,.6
}