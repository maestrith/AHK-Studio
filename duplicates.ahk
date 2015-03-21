duplicates(){
	sc:=csc(),sc.2500(3),sc.2505(0,sc.2006),dup:=[],pos:=posinfo()
	v.lastsearch:=search:=sc.textrange(pos.start,pos.end),v.selectedduplicates:=""
	if StrLen(search)<3
		return
	sc.2190(0),sc.2500(3),sc.2192(sc.2006)
	while,(found:=sc.2197(StrLen(search),[search]))>=0{
		dup.Insert(found),found++
		sc.2190(found),sc.2192(sc.2006)
	}
	if (dup.MaxIndex()>1){
		v.duplicateselect:=1
		for a,b in dup{
			sc.2190(b),sc.2192(sc.2006)
			sc.2504(b,StrLen(search)),found++
		}
		v.selectedduplicates:=dup
	}
}