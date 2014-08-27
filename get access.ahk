get_access(){
	if !access_token{
		access_token:=InputBox(csc().sc,"This feature requires an access token from Github to use","Please enter your access token`nor press cancel to be taken to instructions on how to get an access token")
		if (ErrorLevel||access_token=""){
			Run,http://www.autohotkey.com/board/topic/95515-ahk-11-create-a-gist-post/
			Exit
		}
		settings.add({path:"access_token",text:access_token})
	}
}