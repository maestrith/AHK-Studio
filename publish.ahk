publish(return=""){
	sc:=csc(),text:=update("get").1,save(),mainfile:=ssn(current(1),"@file").text,publish:=update({get:mainfile}),includes:=sn(current(1),"descendant::*/@include/..")
	while,ii:=includes.item[A_Index-1]
		if InStr(publish,ssn(ii,"@include").text)
			StringReplace,publish,publish,% ssn(ii,"@include").text,% update({get:ssn(ii,"@file").text}),All
	rem:=sn(current(1),"descendant::remove")
	while,rr:=rem.Item[A_Index-1]
		publish:=RegExReplace(publish,"m)^\Q" ssn(rr,"@inc").text "\E$")
	ea:=xml.ea(vversion.ssn("//*[@file='" ssn(current(1),"@file").text "']")),newver:="Version=" ea.version
	if InStr(publish,Chr(59) "auto_version")
		publish:=RegExReplace(publish,Chr(59) "auto_version",newver)
	if InStr(publish,Chr(59) "github_version")
		publish:=RegExReplace(publish,Chr(59) "github_version",newver)
	aa:=vversion.ea("//info[@file='" ssn(current(1),"@file").text "']"),repver:=aa.versstyle?newver:"Version=" newver
	if InStr(publish,Chr(59) "auto_version")
		publish:=RegExReplace(publish,Chr(59) "auto_version",repver)
	StringReplace,publish,publish,`n,`r`n,All
	if return
		return publish
	Clipboard:=publish
	MsgBox,,AHK Studio,Project compiled and coppied to your clipboard,.6
}