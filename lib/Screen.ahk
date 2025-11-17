getMonitorHandle()
{
  ; Initialize Monitor handle
  hMon := DllCall("MonitorFromPoint"
	, "int64", 0 ; point on monitor
	, "uint", 1) ; flag to return primary monitor on failure

	
  ; Get Physical Monitor from handle
  VarSetCapacity(Physical_Monitor, 8 + 256, 0)

  DllCall("dxva2\GetPhysicalMonitorsFromHMONITOR"
	, "int", hMon   ; monitor handle
	, "uint", 1   ; monitor array size
	, "int", &Physical_Monitor)   ; point to array with monitor

  return hPhysMon := NumGet(Physical_Monitor)
}

destroyMonitorHandle(handle)
{
  DllCall("dxva2\DestroyPhysicalMonitor", "int", handle)
}

setMonitorBrightnessProgressive(source)
{
	target := source
	if (source) {
		Loop, 15
		{
			setMonitorBrightness(A_Index * 6)
		}
	} else {
		Loop, 15
		{
			setMonitorBrightness(100 - A_Index * 6)
		}
	}
}

setMonitorBrightness(source)
{
  handle := getMonitorHandle()
  DllCall("dxva2\SetVCPFeature"
	, "int", handle
	, "char", 0x10
	, "uint", source)
  destroyMonitorHandle(handle)
}

getMonitorBrightness()
{
  handle := getMonitorHandle()
  DllCall("dxva2\GetVCPFeatureAndVCPFeatureReply"
	, "int", handle
	, "char", 0x10
	, "Ptr", 0
	, "uint*", currentValue
	, "uint*", maximumValue)
  destroyMonitorHandle(handle)
  return currentValue
}