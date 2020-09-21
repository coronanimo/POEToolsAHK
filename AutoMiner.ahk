; -------------------------------
; Copyleft by CoronaNIMO
; kav#sjtuer.net
; -------------------------------

; -------------------------------
; Make sure run as Admin
; -------------------------------
if not A_IsAdmin
Run *RunAs "%A_ScriptFullPath%"

;~  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;~  Globals and Init
;~  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
#SingleInstance Force
#IfWinActive Path of Exile

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Global DetonateOffsetX = -370
Global DetonateOffsetY = -225
Global DetonateAbsX = 0
Global DetonateAbsY = 0
Global Tick = 200
Global DetonateColor = 0xFEFEFE
Global Detonating = 0
Global afterInit = 0
CoordMode, ToolTip, Screen
CoordMode, Pixel, Screen

;~  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;~  Ingame Overlay
;~  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Gui 2:Color, 0X130F13
Gui 2:+LastFound +AlwaysOnTop +ToolWindow
WinSet, TransColor, 0X130F13
Gui 2: -Caption
Gui 2:Font, bold cFFFFFF S10, Arial
Gui 2:Add, Text, x+1 y+2.5 BackgroundTrans vT1, Detonate: OFF


;~  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;~  Flask Script Start (from Internet)
;~  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

~`::
	;Initialize random delays between 57 and 114 ms (arbitrary values, may be changed)
	random, delay2, 57, 114
	random, delay3, 57, 114
	random, delay4, 57, 114
	random, delay5, 57, 114

	send, 1 ;simulates the keypress of the 1 button. If you use another button, change it!

	sleep, %delay2%
	send, 2 ;simulates the keypress of the 2 button. If you use another button, change it!

	sleep, %delay3%
	send, 3 ;simulates the keypress of the 3 button. If you use another button, change it!

	sleep, %delay4%
	send, 4 ;simulates the keypress of the 4 button. If you use another button, change it!

	sleep, %delay5%
	send, 5 ;simulates the keypress of the 5 button. If you use another button, change it!
return


;---------------- Initialize Detonate Position -----------------------
~^D::
afterInit :=1
IfWinExist, ahk_class POEWindowClass
{


	WinGetPos, wLeft, wTop, wWidth, wHeight
	wRight := wLeft + wWidth
	wBottom := wTop + wHeight
	DetonateAbsX1 := wRight - Round(wWidth * 0.2)
	DetonateAbsY1 := wBottom - Round(wHeight * 0.2)
	DetonateAbsX2 := DetonateAbsX1 + Round(wWidth * 0.1)
	DetonateAbsY2 := DetonateAbsY1 + Round(wHeight * 0.1)
	PixelSearch ,Px , Py, %DetonateAbsX1%, %DetonateAbsY1%, %DetonateAbsX2%, %DetonateAbsY2%, %DetonateColor%, 1, Fast	
	if ErrorLevel{
		MsgBox , Cannot find the Detonate Button
	} else {
		MsgBox , The Detonate Button is found X:%Px% Y:%Py%
		DetonateAbsX := Px
		DetonateAbsY := Py
	}
	SetTimer ,RemoveToolTip, -2000	
	Detonating := 0
	Gui2X := DetonateAbsX - 20
	Gui2Y := DetonateAbsY + 16
	Gui 2:Show, x%Gui2X% y%Gui2Y%
	return
} else {
	return
}



~D::

if (!afterInit) {
	return
}


if (Detonating) {
	GuiControl, 2:, T1, Detonate: OFF
	Detonating := 0
	SetTimer, DetonateLoop, off	
} else {
	GuiControl, 2:, T1, Detonate: ON
	Detonating := 1
	SetTimer, DetonateLoop, %Tick%
	
}
return

~^R::Reload

~F10::ExitApp

DetonateLoop:
IfWinActive, ahk_class POEWindowClass
{
	if (GetKeyState("shift", "p")){
		return
	}else{
		PixelSearch, Px, Py, %DetonateAbsX%, %DetonateAbsY%, %DetonateAbsX%, %DetonateAbsY%, %DetonateColor%, 1, Fast
		if ErrorLevel{
			return
		}
		else
			send {d}
	}
}
return

RemoveToolTip:
	Tooltip ,
return


