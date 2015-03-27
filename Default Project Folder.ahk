Default_Project_Folder(){
	FileSelectFolder,directory,,3,% "Current Default Folder: " settings.ssn("//directory").text
	settings.add2("directory","",directory)
}