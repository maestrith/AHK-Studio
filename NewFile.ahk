NewFile(mainfile,newfile){
	SplitPath,mainfile,mfn,moutdir
	SplitPath,newfile,nfn,noutdir
	top:=ssn(current(1),"descendant::file[@file='" mainfile "']"),tv:=ssn(top,"@tv").text
	if(moutdir!=noutdir){
		for a,b in build:=StrSplit(RelativePath(mainfile,newfile),"\"){
			if(a!=build.MaxIndex()){
				folder.=b "\"
				if !tt:=files.ssn("//main[@file='" mainfile "']descendant::folder[@folder='" folder "']")
					top:=files.under(top,"folder",{folder:b,tv:child:=TV_Add(b,ssn(top,"@tv").text)})
				else
					top:=tt
				child:=ssn(top,"@tv").text
			}
		}
	}else
		top:=current(1),child:=ssn(current(1).firstchild,"@tv").text
	return {obj:top,tv:child}
}