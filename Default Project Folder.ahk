Default_Project_Folder(){
	FileSelectFolder,directory,,3,% "Current Default Folder: " settings.ssn("//directory").text
	settings.Add({path:"directory",text:directory})
}