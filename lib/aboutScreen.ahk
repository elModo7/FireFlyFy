; Note to myself: Do NOT take this class as reference, use other or the generic! This one is ONLY for FireFlyFy
; About Screen for my projects v0.0.8
FileCreateDir % A_Temp "/font"
FileInstall, res\font\BaiJamjuree.ttf, % A_Temp "\font\BaiJamjuree.ttf", 0
global fnt := A_Temp "\font\BaiJamjuree.ttf"
global font1 := New CustomFont(fnt)
global activableAboutButtons := ["Static6", "Static7", "Static8", "Static9", "Static10", "Static11", "Static12", "Static13", "Static14"] ; Social media icons
global hCursorAboutHand := DllCall("LoadCursor", "UInt", NULL, "Int", 32649, "UInt") ; 32649 -> IDC_HAND
global hCursorAboutArrow := DllCall("LoadCursor", "UInt", NULL, "Int", 32512, "UInt") ; 32512 -> IDC_ARROW

;~ showAboutScreen("My APP", "This app does amazing things.")
showAboutScreen(title, description){
	Gui, about:destroy ; Normally this is not needed but just in case destroy previous about window
	exitButtonB64 := "iVBORw0KGgoAAAANSUhEUgAAACoAAAAoCAYAAACIC2hQAAAAAXNSR0IArs4c6QAAApNJREFUWAntWEFrE1EQntmNVfGih0Lr5uZF7UFBQS/RHit6UVAQhNJDjUm9evcHeGxq6klJDzXxoNDgwWJQPNqTh9qCErFNKEHPQk3GGc22L0tf+/J2FRZ34fHmzXwz35d5u2/Z4BBNE8TgcmKg8bfERGjUO5UKFkRwzjYxvxT0/8v1MM2cIei8VzmTrVe7EYWddDSKLqo1ko6q3YjC/n86ymferetUdnVdk5hgdHFTv3VH7xM5w1R4xAdz6R20yiNUHgiSik9ighGs5AQxpmurxFGqpWahUCKgSSHi+dp3aD1PU/mgTyw2+15IrIuZlBzJ9TH9zFZJq7B8jEnGVCIWdKkNrZcjVLgifha5wL6LKobtsW7uSsC/59Kqow3Mr7iwb5Srb6gMIuwbwKKMHURuSI7kqjmmtpVQKb6G2Q8uDFxANnvJ6BzfDDy2LwT8KljJ2fb2Z1kLFZp1vL26H9wMAH7ehfYTC88IdhfMnqFQQqV6HXN1LjKuY3LAHW/i3S+6uKk/tNCjNHucP7rmdYR8ND0VjC5u6g8l1KPCaYLNt/zgeDpCiQnGo+IpHcbEby3Uo5nzHaAad3MwQPSa1zK2LsF0oF1L03TPQ7YFMDCshA5R8WQb6BULONzLgdUDcOiyDH7AqmqMO3vkJ+Aiv6FOqH5T20poE7LLfCzN9ZJgxYPU1TpO/JAhNoutqBgHsNSA/EfVZ2pbCUVEauJUjokf/CHCxxkYvLmE2U2fWGzxMcET8QmWD/u85PqYfmarV6hP0MCpex49fLMGd6o7CajgjTYRTaSh+Gwdcwt+ns0cSqgQigCEnJa7+wNCiZTiVluvVfUXA4nQqJubdDTpaNQdiLpebO5RTP7Dj3jvY7P1sRH6C6/z2F0v5TZEAAAAAElFTkSuQmCC"

	discordImgB64 := "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAB6klEQVRIie2Wz04TURTGv3PudG7BdgKkMTH6AsQHcMte3ZnYLkTCHykmRJ/BFzCmJiNVQjBghfgOJu5N3PEE7iCBMkA7M/deF63tDL2Uoulu7mruuWe+39xz8p0MlVeaGOdyxqqeATLA+AEUUjjzZUsDovLiNHmixMW+f1vjZH7RU04wTOMqo71+FT+4Pz3iZx4cHL95K6xH9hvEbEZXBzA7O+XGQeiYUQF7fmF09c7a3ixUVk8H43YAE98UAAIhMshdD6jXbq4OANiqTS+sX264BVCUt/4NICUNBq/1QauyokAaQKNe7EWfVg9ZSy2CPf9OSk5xLPQwgMAF0BdSYFDUeTbGEBEAqJi1BMCqELa1K/slbXHLgTsM8MmfSm5JBfjbN4Lq5BsOewnshEC+t93xvYWXrWGAvMoh4RgWM4qPhRZa/wTNdUk06cnfzbYHajuimHxdcKo+FoByjUCqV/sfOneaSwY3ancBJIvZlWMJhKnIpQwT0/8MwDitbgGUl46+bZd624+NX99/lHbf39MiEkkTGYDOnq/R40fhk4f9ts0vB+CU1+zD7vO7fG6imxcb82zVPi8bG8VuOQ2gzytrajDnymlKiDZrhQnplqtN0hYHAdBQX+veeXS4WC2xOLPrZP9FGSAD4A/xf5WFX7IbLgAAAABJRU5ErkJggg=="
	
	youtubeImgB64 := "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAACXBIWXMAAA7EAAAOxAGVKw4bAAABD0lEQVRIiWN8oqvOQEvA8v8/Tc1nYPlPYxtYaOwBOgTRv9EgImwBARsUDx9jFhXFKvX37dv71hb4tTPeUlNBE1K9eZt4B6KB2+qqaCJUjgNM0xivqyoj8zVu3aHQjhuoQUL9SEYzkIQguqaqonWbsP/QDCShLPr///9VFeXnf/64PHiIXxmaBUSaD/W7BDPLFWXl53/+uD7Ebg16EP0j1nwGZJW4TEdTxkCGD/Tv3SVGGbIFxNpA0GiYBWhxQKTxRAPMVERtC1ANZDwtp4CmwuThfbJNPyOviCZC+7LopKwCHg2swsKG58/gUXBWW+/v5894FDCekJEn0nXkATrUaLQ1nx6tiiEfRLRvm9LYCwBTQH2k9AacGQAAAABJRU5ErkJggg=="
	
	githubImgB64 := "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAArUlEQVRIie1VQQ4EIQhDMxf+/zuTeQp2D5MYE4WSbGb3Yo9CW0VBkYODX6G1hgn3fSeJhWYAiPiFKJBwrJ7xiGIZderhBoZ6KcVzmkOex351VowrQDOvgPwWVHU8x0z+SFbVNbo5VL4+mfzXS3QMKP7aB0+jPhIrOfmIyajwhsGq7h2U38GWCSDTIpKZpp4B3QQ3EJHe+yBvSwSg1hqLcAAws3nFzPK/xcHBl/gAWm13TIXS49wAAAAASUVORK5CYII="
	
	instagramImgB64 := "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"
	
	linkedinImgB64 := "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAA7EAAAOxAGVKw4bAAAA60lEQVRYhWNkgIG63f8Z6AmaXBkZGBgYGAfEciRHMA6Y5VDAMpCWE3TA/0YXBsb6PTR1ANYo+N/ogsLnadnP8PX3X5o4gKgo+FLjSLOQwHAAuu9pDTAcwFi/h66OwBoFvcceMhRbyaM4ilZgtBzA6gBsaQA5GtDlYXK40g6+KKRaCOBLuPgKNKo4gJhcg8sRgzMNkANq9t5laD10H87HFiosTIwMf/6hZjqqOQDZcgYGBoY1114yhGiJo4j9rnfGiAaqOABb3IauvMzwv1Eci2pUMHzSwKgDRh0w6oAh64DRFtEg6JzCwAB1zwF+slKBqkCL/AAAAABJRU5ErkJggg=="
	
	linktreeImgB64 := "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAACXBIWXMAAA7EAAAOxAGVKw4bAAABdElEQVRIiWN0fpbAQEvAQlPTRy0YtQATMDIxMjAw/P/3n1YW7JGYz8DAQFLWIWzBpaR93+9/Mt8fgCZ+0nEDpyKf3jwniiy403L29Y5HDAwMZwO2G2/whIufctv05eaHLzc/3Gk5q1JjjMcERoL+vZp7+MXauwwMDMJO0m/3PWVgYBCwkPhw4gUDA4NEsLL2ZFv82glbwMDA8HDalTstZ9AEVWtN5DJ1COrFZ8FeqQUE9UMAHkMGNB+IByjC2S833McjS6YFOtPsIYwTjhsgDJUaY4b/DHdazzIwMHy5/t4CI+2SZgEEHDVZ/ePZVwYGBtU6U7kMbYjgndazX29+OGqy2vpMKEUWvN75CGp6jQncdPlsXUZGxtstZ348+/p612NRN1k8JhBOpm/3P/164z0kRULSFUTL/f6LgpYSAhbiFPmAgYFB2FFa2FEaU1yxUJ+gXqIsoBCMNAucnycwMDAwkFDfkOoDUowmywLSwagFI8ACAHrZevac5Q3CAAAAAElFTkSuQmCC"
	
	portfolioImgB64 := "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAEY0lEQVRIiXWWXYhVVRTHf2ufYxMVkTmGKI7NVCDag0VPUjmSYlKkMFaGBAUaYT30MPeOWDr3jmbT3KuFED0k1EsQFkVfJKlk1msTBGoSKmFjRPZhHxhyz/n3cL72mXtmPxz22Xvt9fFf/7X2NtVBYIA3AQxiMFD62z5hw0tVIZzLVB03jWSKrGyJdPLUp+6NkzFd46Uh29YvXPdOZgAQpvoMEoIY2zvDbi5VK3vtOwdAmG6UV4HzHfpeqdD43Nrw1c86haMtol24vzPVPkoVEXgQWStdW9rLiYuAHXpca+YV53cfYcdkOo/2BO7PqNCTyKQ5yA14xt2ECSUIfHjW1g2ohIAVR3I/NAb/VIARlswagCIS7Y1NAOsGVIran8PogzQ/ATj5G0t6PO2ZpS6IQBFuH+QJFLiMaZSFDcAmsoWRgtNpPhxhKfUGEM/OrSd4lSmfC7sKanSbD0s1YiCCv9QtV/Hbrd1fyfIcpqfyoCxXYaDpsGSx7T+LGUFgW/s0usGa76kk4Dkd4rtY4oAUOrenqOE759o3Twhy5hjYM+hql52ZFpMDJRBVRG2gnj1S3WxCQDL56Fdb95Y+2GJDBxRLIA3j2pZMpubYgt/L8JIkuYQMgGpyLbZvgkiqYS10rYCHbpKD9TcoqtE4Z41+IeKarMVlrH+brtTKYLiEpiqDY0SOcDyxVEgfd3ZvrJS1HkdTD0Z45F07OKSCb0UEPjCAsB6AuEbjHI1+EtxVS7n7+R82PqkVi2i8j4YLwgSRB0NWN1a0w1IjMlDivnxaAXDkEquu99q7CPfSqVUT14sguSIcgIbV2w5QhMv2hU2Y6tp5ylYuNlxMnK4f+48XHuW+L+zoYEXhhXmAWKo9WfmlGY2eoTkvlbscGOidi7brY339EytXFygfPw8BRwdVebVZmsZp3UYZ7vW0ZRourhU1YS1GN1qjT8nuHTfa5GYVqr1vuRfl2v1cucSMd2saqgNCHJgKoTO5OburfUeLXuQTyyPVvCCwdpSywEC4lqsv1/jdSTsn7rMtrU7hUyUMabv2uqkfYNKKR4do3FI6NnbaDd6sFfuTIodrjH9VUl3koN4FnGcpv7BmGoeftFW9avxIHDM2UN5LGFyo83uGAFzLPbBAh6d0ZQbt6xcGq3ojoHmQxsPZMf/tU/Fs8eJoXKD5NqpBTLCP2CPCLKNoO2L0PM2FNL9ndHFlBNNeZPDtZTa8yZmtNEmzF9WYPrJTg1/asUEBug6M539wL97qETrNASkHXMt2rKa5TNYKVe9I7DwV7FoSlXLjjWAis51jK4DbXrPTz+KkFKLICF/Oemfi33yzC+rMdrO2x0A8gsmjgFAPbjfAjK9b4VrYmoVu+bJ4Z45d4kgErnguzDSevp25vdgc1xyI2z+74fleMWZdPTz0WNfDVlibHfc71WNFNL5j7HC1gdfXsu0rxgdi4NJUzHxPewZXSHeJpfdMDJjjrkVVT9dsjN8DxlVtrgx3vW4A43/3FwK74dJb+wAAAABJRU5ErkJggg=="
	
	twitterImgB64 := "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAA7EAAAOxAGVKw4bAAABZ0lEQVRYhe2WP0vDQBjGf1dj/TcU0TYgiBUUQRzEpcUhS9tJxdHNL+LSxcWv4Ky0Dn6CghiKCK4iCIKCQ1sVVByUWoyLEaXt3eWiIJJnCrl78vzu8t7LCYCCW/fePIw0Eo8Z+WICStmUELnDumF0OABfVij3DygCiAD+B0A5m2x7t3Z8C8Dm3DAbp/dmABXHJu82pOG7mfbwr1CvrZbUr9yBimNTPHukevfScbxHyP29lkXz+oL4+JQZAEBxNgEklLvRSSvlIwYnpruOB6qBimN/PuvCyMKVAHm38S20G0wYKYvwt/W3+4DsF+jI7wXGAD5E8+ocd90xBgkFMPl8w7ZBuM7qtQAuB1J4gKLfGEurCAsfZ95+qrGzNK+cr7t6bQCAUibJaJ+6IIOESwGCVv9yqcpQeiaQB0B5K17ggS2n+4dX90/oH0sHDtYGUCm6lkcAEUBYCYDcQc0jZtbtjY+h57G3aIt3hUldQg3TORoAAAAASUVORK5CYII="
	; END OF IMAGE DATA

	; GDI+ Startup
	hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll") ; Load module
	VarSetCapacity(GdiplusStartupInput, (A_PtrSize = 8 ? 24 : 16), 0) ; GdiplusStartupInput structure
	NumPut(1, GdiplusStartupInput, 0, "UInt") ; GdiplusVersion
	VarSetCapacity(pToken, 0)
	DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &GdiplusStartupInput, "Ptr", 0) ; Initialize GDI+

	exitButton := GdipCreateFromBase64(exitButtonB64, 2)
	discordImg := GdipCreateFromBase64(discordImgB64, 2)
	youtubeImg := GdipCreateFromBase64(youtubeImgB64, 2)
	githubImg := GdipCreateFromBase64(githubImgB64, 2)
	instagramImg := GdipCreateFromBase64(instagramImgB64, 2)
	linkedinImg := GdipCreateFromBase64(linkedinImgB64, 2)
	linktreeImg := GdipCreateFromBase64(linktreeImgB64, 2)
	portfolioImg := GdipCreateFromBase64(portfolioImgB64, 2)
	twitterImg := GdipCreateFromBase64(twitterImgB64, 2)

	; Free GDI+ module from memory
	DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)

	Gui about:+LastFound -Caption +AlwaysOnTop -Resize +ToolWindow
	Gui about:Color, 0x000015
	Gui about:Add, Picture, x16 y8 w128 h128 gmoveWindow, % A_Temp "\" appName "\FireFlyFy.png"
	Gui about:Font, s16 c0x8080FF, Bai Jamjuree Bold
	Gui about:Add, Text, x152 y8 w386 h23 +0x200 gmoveWindow, % title
	Gui about:Font, s12 c0x00FF80, Bai Jamjuree Bold
	Gui about:Add, Text, x16 y136 w128 h60 +Center gmoveWindow, elModo7
	Gui about:Font, s12 c0x80FFFF, Bai Jamjuree Bold
	Gui about:Add, Text, x16 y156 w128 h60 +Center gmoveWindow, VictorDevLog
	Gui about:Font, s12 c0x80FFFF, Bai Jamjuree
	Gui about:Add, Text, x152 y32 w412 h103 +Left gmoveWindow, % description
	Gui about:Add, Picture, x544 y8 w21 h20 gAboutGuiClose, % "HBITMAP:*" exitButton
	Gui about:Add, Picture, x248 y136 w32 h32 glinkGithub, % "HBITMAP:*" githubImg
	Gui about:Add, Picture, x288 y136 w32 h32 glinkYoutube, % "HBITMAP:*" youtubeImg
	Gui about:Add, Picture, x408 y136 w32 h32 glinkLinkedin, % "HBITMAP:*" linkedinImg
	Gui about:Add, Picture, x448 y136 w32 h32 glinkInstagram, % "HBITMAP:*" instagramImg
	Gui about:Add, Picture, x488 y136 w32 h32 glinkTwitter, % "HBITMAP:*" twitterImg
	Gui about:Add, Picture, x528 y136 w32 h32 glinkDiscord, % "HBITMAP:*" discordImg
	Gui about:Add, Picture, x328 y136 w32 h32 glinkPortfolio, % "HBITMAP:*" portfolioImg
	Gui about:Add, Picture, x368 y136 w32 h32 glinkLinktree, % "HBITMAP:*" linktreeImg
	Gui about:Font, s10 c0xFFFF80, Bai Jamjuree
	Gui about:Add, Text, x152 y175 w413 h35 +Right gmoveWindow, Víctor Santiago Martínez Picardo (elModo7 / VictorDevLog) %A_YYYY%
	Gui about:Show, w573 h200, About Window
	
	OnMessage(0x200, "WM_MOUSEMOVE_ABOUT")
}

WM_MOUSEMOVE_ABOUT(wParam, lParam) {
	global hCursorAboutHand, hCursorAboutArrow, activableAboutButtons
	MouseGetPos,,,, ctrl
	activableControl := HasVal(activableAboutButtons, ctrl)
	if (activableControl) {
		DllCall("SetCursor", "Ptr", hCursorAboutHand)
	} else if (!activableControl) {
		DllCall("SetCursor", "Ptr", hCursorAboutArrow)
	}
}

AboutGuiClose(){
	Gui, about:destroy
	DllCall("DestroyCursor","Uint", hCursorAboutArrow)
	DllCall("DestroyCursor","Uint", hCursorAboutHand)
}

linkGithub(){
	Run, https://github.com/elModo7
}

linkYoutube(){
	Run, https://www.youtube.com/@VictorDevLog?sub_confirmation=1
}

linkLinkedin(){
	Run, https://www.linkedin.com/in/victor-smp
}

linkInstagram(){
	Run, https://www.instagram.com/victordevlogyt
}

linkTwitter(){
	Run, https://x.com/VictorDevLog
}

linkDiscord(){
	Run, https://discord.gg/aYFXQjGA6b
}

linkPortfolio(){
	Run, https://elmodo7.github.io/
}

linkLinktree(){
	Run, https://linktr.ee/VictorDevLog
}

moveWindow(){
	PostMessage, 0xA1, 2,,, A 
}

GdipCreateFromBase64(B64, RetType := 0) { ; 0=pBitmap, 1=HICON, 2=HBITMAP
	VarSetCapacity(B64Len, 0)
	DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", StrLen(B64), "UInt", 0x01, "Ptr", 0, "UIntP", B64Len, "Ptr", 0, "Ptr", 0)
	VarSetCapacity(B64Dec, B64Len, 0) ; pbBinary size
	DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", StrLen(B64), "UInt", 0x01, "Ptr", &B64Dec, "UIntP", B64Len, "Ptr", 0, "Ptr", 0)
	pStream := DllCall("Shlwapi.dll\SHCreateMemStream", "Ptr", &B64Dec, "UInt", B64Len, "UPtr")
	VarSetCapacity(pBitmap, 0)
	DllCall("Gdiplus.dll\GdipCreateBitmapFromStreamICM", "Ptr", pStream, "PtrP", pBitmap)

	If (RetType = 2) {
		VarSetCapacity(hBitmap, 0)
		DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "UInt", pBitmap, "UInt*", hBitmap, "Int", 0XFFFFFFFF)
	}

	If (RetType = 1) {
		DllCall("Gdiplus.dll\GdipCreateHICONFromBitmap", "Ptr", pBitmap, "PtrP", hIcon, "UInt", 0)
	}

	ObjRelease(pStream)

	return (RetType = 1 ? hIcon : RetType = 2 ? hBitmap : pBitmap)
}

/*
	CustomFont v2.00 (2016-2-24)
	---------------------------------------------------------
	Description: Load font from file or resource, without needed install to system.
	---------------------------------------------------------
	Useage Examples:

		* Load From File
			font1 := New CustomFont("ewatch.ttf")
			Gui, Font, s100, ewatch

		* Load From Resource
			Gui, Add, Text, HWNDhCtrl w400 h200, 12345
			font2 := New CustomFont("res:ewatch.ttf", "ewatch", 80) ; <- Add a res: prefix to the resource name.
			font2.ApplyTo(hCtrl)

		* The fonts will removed automatically when script exits.
		  To remove a font manually, just clear the variable (e.g. font1 := "").
*/
Class CustomFont
{
	static FR_PRIVATE  := 0x10

	__New(FontFile, FontName="", FontSize=30) {
		if RegExMatch(FontFile, "i)res:\K.*", _FontFile) {
			this.AddFromResource(_FontFile, FontName, FontSize)
		} else {
			this.AddFromFile(FontFile)
		}
	}

	AddFromFile(FontFile) {
		DllCall( "AddFontResourceEx", "Str", FontFile, "UInt", this.FR_PRIVATE, "UInt", 0 )
		this.data := FontFile
	}

	AddFromResource(ResourceName, FontName, FontSize = 30) {
		static FW_NORMAL := 400, DEFAULT_CHARSET := 0x1

		nSize    := this.ResRead(fData, ResourceName)
		fh       := DllCall( "AddFontMemResourceEx", "Ptr", &fData, "UInt", nSize, "UInt", 0, "UIntP", nFonts )
		hFont    := DllCall( "CreateFont", Int,FontSize, Int,0, Int,0, Int,0, UInt,FW_NORMAL, UInt,0
		            , Int,0, Int,0, UInt,DEFAULT_CHARSET, Int,0, Int,0, Int,0, Int,0, Str,FontName )

		this.data := {fh: fh, hFont: hFont}
	}

	ApplyTo(hCtrl) {
		SendMessage, 0x30, this.data.hFont, 1,, ahk_id %hCtrl%
	}

	__Delete() {
		if IsObject(this.data) {
			DllCall( "RemoveFontMemResourceEx", "UInt", this.data.fh    )
			DllCall( "DeleteObject"           , "UInt", this.data.hFont )
		} else {
			DllCall( "RemoveFontResourceEx"   , "Str", this.data, "UInt", this.FR_PRIVATE, "UInt", 0 )
		}
	}

	; ResRead() By SKAN, from http://www.autohotkey.com/board/topic/57631-crazy-scripting-resource-only-dll-for-dummies-36l-v07/?p=609282
	ResRead( ByRef Var, Key ) {
		VarSetCapacity( Var, 128 ), VarSetCapacity( Var, 0 )
		If ! ( A_IsCompiled ) {
			FileGetSize, nSize, %Key%
			FileRead, Var, *c %Key%
			Return nSize
		}

		If hMod := DllCall( "GetModuleHandle", UInt,0 )
			If hRes := DllCall( "FindResource", UInt,hMod, Str,Key, UInt,10 )
				If hData := DllCall( "LoadResource", UInt,hMod, UInt,hRes )
					If pData := DllCall( "LockResource", UInt,hData )
						Return VarSetCapacity( Var, nSize := DllCall( "SizeofResource", UInt,hMod, UInt,hRes ) )
							,  DllCall( "RtlMoveMemory", Str,Var, UInt,pData, UInt,nSize )
		Return 0
	}
}

HasVal(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}