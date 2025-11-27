showAboutScreen:
	showAboutScreen(appName " v" version, i18n.t("about_description"))
return

aboutGuiEscape:
aboutGuiClose:
	AboutGuiClose()
return

settingsGuiEscape:
settingsGuiClose:
	changeTempLanguage(false)
    Gui settings:Destroy
return

appConfigurationGuiEscape:
appConfigurationGuiClose:
    Gui appConfiguration:Destroy
return

configuredAppsGuiEscape:
configuredAppsGuiClose:
    Gui configuredApps:Destroy
return

ExitSub:
	gosub, gdipUnload
	ExitApp
	
initMouseFollower:
	pToken := Gdip_Startup()
	pBitmap1 := Gdip_CreateBitmapFromFile(A_Temp "\" appName "\FireFlyFy_FireFly.png")
	Width1 := Gdip_GetImageWidth(pBitmap1), Height1 := Gdip_GetImageHeight(pBitmap1)
	Gui, flyingFireFly: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs +Hwndhwnd1
	Gui, flyingFireFly: Show, NA
	hbm1 := CreateDIBSection(145, 100)
	hdc1 := CreateCompatibleDC()
	obm1 := SelectObject(hdc1, hbm1)
	G1 := Gdip_GraphicsFromHDC(hdc1)
	Gdip_SetInterpolationMode(G1, 7)
return

gdipUnload:
	Gdip_DisposeImage(pBitmap1)
	Gdip_DeleteGraphics(G1)
	SelectObject(hdc1, obm1)
	DeleteDC(hdc1)
	DeleteObject(hbm1)
	Gdip_Shutdown(pToken)
return