class github{
	static url:="https://api.github.com",http:=[]
	__New(owner){
		token:=settings.ssn("//github/@token").text
		;FileRead,token,token.txt
		if !(token){
			InputBox,token,Please enter your github access token,An access token is required to use this.`nIf you do not have one press Cancel and it will take you to get one.`nMake sure that you have repo selected when creating a new token
			if ErrorLevel
				Run,https://github.com/settings/applications
			if !token
				return
			settings.Add({path:"github",att:{token:token}})
		}
		this.http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
		this.token:="?access_token=" token
		this.owner:=owner
		return this
	}
	CreateRepo(name,description="Created with AHK Studio",homepage="",private="false",issues="false",wiki="true",downloads="true"){
		if FileExist("github\" name ".ini")
			return m("Repo exists.  Please choose another name")
		url:=this.url "/user/repos" this.token
		this.http.Open("POST",url)
		json=
		(
		{"name":"%name%","description":"%description%","homepage":"http://www.maestrith.com","private":%private%,"has_issues":%issues%,"has_wiki":%wiki%,"has_downloads":%downloads%}
		)
		this.http.Send(json)
		FileDelete,github\%name%.orig
		FileAppend,% this.http.ResponseText,github\%name%.orig
		IniWrite,% name:=this.json("name",this.http.ResponseText),github\%name%.ini,Repo,name
		return name
	}
	CreateFile(repo,filefullpath,text,commit="First Commit",realname="",email=""){
		SplitPath,filefullpath,filename
		url:=this.url "/repos/" this.owner "/" repo "/contents/" filename this.token,file:=this.encode(text)
		json=
		(
		{"message":"%commit%","committer":{"name":"%realname%","email":"%email%"},"content": "%file%"}
		)
		this.http.Open("PUT",url)
		this.http.send(json)
		RegExMatch(this.http.ResponseText,"U)"Chr(34) "sha" Chr(34) ":(.*),",found)
		sha:=Trim(found1,Chr(34))
		if sha
			IniWrite,%sha%,github\%repo%.ini,%filefullpath%,sha
	}
	Update(repo,filefullpath,text,commit="Updated",branch="master"){
		SplitPath,filefullpath,filename
		IniRead,sha,github\%repo%.ini,%filefullpath%,sha,0
		if !sha
			return m("File does not exist.  Please create the file first")
		url:=this.url "/repos/" this.owner "/" repo "/contents/" filename this.token
		text:=this.encode(text)
		json=
		(
		{"message":"%commit%","content":"%text%","sha":"%sha%","branch":"%branch%"}
		)
		this.http.Open("PUT",url)
		this.http.Send(json)
		RegExMatch(this.http.ResponseText,"U)"Chr(34) "sha" Chr(34) ":(.*),",found)
		if sha:=Trim(found1,Chr(34))
			IniWrite,%sha%,github\%repo%.ini,%filefullpath%,sha
		Else
			m("an error occured")
	}
	json(search,text){
		RegExMatch(text,"U)" Chr(34) search Chr(34) ":(.*),",found)
		return Trim(found1,Chr(34))
	}
	Encode(text){ ;original http://www.autohotkey.com/forum/viewtopic.php?p=238120#238120
		if text=""
			return
		cp:=0
		VarSetCapacity(rawdata,StrPut(text,"utf-8")),sz:=StrPut(text,&rawdata,"utf-8")-1
		DllCall("Crypt32.dll\CryptBinaryToString","ptr",&rawdata,"uint",sz,"uint",0x40000001,"ptr",0,"uint*",cp)
		VarSetCapacity(str,cp*(A_IsUnicode?2:1))
		DllCall("Crypt32.dll\CryptBinaryToString","ptr",&rawdata,"uint",sz,"uint",0x40000001,"str",str,"uint*",cp)
		return str
	}
	List(repo,sha=""){
		url:=this.url "/repos/" this.owner "/" repo "/commits"
		add:=sha?"/" sha this.token:this.token
		url.=add
		this.http.Open("GET",url)
		this.http.Send()
		FileDelete,commits.txt
		FileAppend,% this.http.ResponseText,commits.txt
		Run,commits.txt
	}
}