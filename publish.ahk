publish(return=""){
	sc:=csc(),text:=update("get").1,save(),mainfile:=ssn(current(1),"@file").text,publish:=update({get:mainfile}),includes:=sn(current(1),"descendant::*/@include/..")
	while,ii:=includes.item[A_Index-1]
		if InStr(publish,ssn(ii,"@include").text)
			StringReplace,publish,publish,% ssn(ii,"@include").text,% update({get:ssn(ii,"@file").text}),All
	rem:=sn(current(1),"descendant::remove")
	while,rr:=rem.Item[A_Index-1]
		publish:=RegExReplace(publish,"m)^\Q" ssn(rr,"@inc").text "\E$")
	ea1:=xml.ea(vversion.ssn("//*[@file='" current(2).file "']"))
	ea:=xml.ea(vversion.ssn("//*[@file='" current(2).file "']/descendant::*[@number!='']")),newver:=(ea1.versstyle?"":"Version=") ea.number
	if InStr(publish,Chr(59) "auto_version")
		publish:=RegExReplace(publish,Chr(59) "auto_version",newver)
	StringReplace,publish,publish,`n,`r`n,All
	if return
		return publish
	Clipboard:=publish
	MsgBox,,AHK Studio,Project compiled and copied to your clipboard,.6
}