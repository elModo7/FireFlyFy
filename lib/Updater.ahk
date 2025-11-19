lookForUpdates(silent := false){
	global
	gitHubData := JSON.Load(urlDownloadToVar("https://api.github.com/repos/elModo7/" appName "/releases/latest"))
	gitHubVersion := gitHubData.tag_name
	versionDiff := VerCmp(gitHubVersion, version)
	if(versionDiff == "-1" && !silent){
		MsgBox 0x40, Nightly Build Detected, % "Your " appName " is more recent than the current public version:`n`nLocal: v" version "`nGitHub: v" gitHubVersion
	}else if(versionDiff == "0" && !silent){
		MsgBox 0x40, Up to date, % appName " is up to date: v" version
	}else if(versionDiff == "1"){
		MsgBox 0x44, New version available!, % "There is a new " appName " version:`n`nLocal: v" version "`nGitHub: v" gitHubVersion "`n`nDo you want to go to the downloads page now?"
		IfMsgBox Yes, {
			downloadLatestVersion()
		}
	} else {
		MsgBox 0x30, Warning!, % "Could not find any " appName " update server."
	}
}

downloadLatestVersion(){
	global appName
	Run, % "https://github.com/elModo7/" appName "/releases/latest"
}

; Since VerCompare is > 1.1.36.1 I will use this to keep compatibility with lower versions of AHK
VerCmp(V1, V2) {           ; VerCmp() for Windows by SKAN on D35T/D37L @ tiny.cc/vercmp 
Return ( ( V1 := Format("{:04X}{:04X}{:04X}{:04X}", StrSplit(V1 . "...", ".",, 5)*) )
       < ( V2 := Format("{:04X}{:04X}{:04X}{:04X}", StrSplit(V2 . "...", ".",, 5)*) ) )
       ? -1 : ( V2<V1 ) ? 1 : 0
}