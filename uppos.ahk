uppos(){
	sc:=csc()
	line:=sc.2166(sc.2008)
	if (lastline!=line)
		hltline()
	lastline:=line
	if (Abs(sc.2008-sc.2009)>2)
		duplicates()
	Else if v.duplicateselect
		sc.2500(3),sc.2505(0,sc.2006),v.duplicateselect:="",v.selectedduplicates:=""
	if (sc.2353(sc.2008-1)>0)
		sc.2351(v.bracestart:=sc.2008-1,v.braceend:=sc.2353(sc.2008-1)),v.highlight:=1
	else if (sc.2353(sc.2008)>0)
		sc.2351(v.bracestart:=sc.2008,v.braceend:=sc.2353(sc.2008)),v.highlight:=1
	else if v.highlight
		v.bracestart:=v.braceend:="",sc.2351(-1,-1),v.highlight:=0
	text:="Line:" sc.2166(sc.2008)+1 " Column:" sc.2129(sc.2008) " Length:" sc.2006 " Position:" sc.2008
	if (sc.2008!=sc.2009)
		text.=" Selected Count:" Abs(sc.2008-sc.2009)
	v.lastwidth:=sc.2276(32,text "AA"),SB_SetParts(v.lastwidth),SB_SetText(text,1)
}