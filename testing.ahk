testing(){
	;m("testing")
	repo=AHK-Studio
	ea:=settings.ea("//github")
	if !(ea.name&&ea.email&&ea.token&&ea.owner)
		return update_github_info()
	git:=new github(ea.owner,ea.token)
	
	sha:=git.getref(repo)
	;GET /repos/:owner/:repo/git/trees/:sha
	;send(verb,url,data="")
	;this.token
	url:=git.url "/repos/" git.owner "/" repo "/git/commits/" sha git.token
	;"tree":{"sha":"135a292d692fc79ab48f8f0cbbda201d81b20af1"
	;url:=git.url "/repos/" git.owner "/" repo "/git/trees/" sha git.token ;get the tree sha
	info:=git.Send("GET",url)
	clipboard:=info
	m(info)
	/*
		sc:=csc()
		info:=StrSplit(sc.getseltext(),",")
		replace:=info.2 ":=InputBox(," Chr(34) info.3 Chr(34) "," Chr(34) info.4 Chr(34) "," Chr(34) info.12 Chr(34) ")"
		sc.2170(0,replace)
	*/
}

/*
	{"sha":"f177b4cea86ef566df2c134360ecb21cd06598de","url":"https://api.github.com/repos/maestrith/AHK-Studio/git/commits/f177b4cea86ef566df2c134360ecb21cd06598de","html_url":"https://github.com/maestrith/AHK-Studio/commit/f177b4cea86ef566df2c134360ecb21cd06598de","author":{"name":"maestrith","email":"maestrith@gmail.com","date":"2014-08-30T03:18:22Z"},"committer":{"name":"maestrith","email":"maestrith@gmail.com","date":"2014-08-30T03:18:22Z"},"tree":{"sha":"135a292d692fc79ab48f8f0cbbda201d81b20af1","url":"https://api.github.com/repos/maestrith/AHK-Studio/git/trees/135a292d692fc79ab48f8f0cbbda201d81b20af1"},"message":"Create README.md","parents":[{"sha":"25572df4a1fd69fd63cf4a7c6ed1711973c2ed6b","url":"https://api.github.com/repos/maestrith/AHK-Studio/git/commits/25572df4a1fd69fd63cf4a7c6ed1711973c2ed6b","html_url":"https://github.com/maestrith/AHK-Studio/commit/25572df4a1fd69fd63cf4a7c6ed1711973c2ed6b"}]}	
*/