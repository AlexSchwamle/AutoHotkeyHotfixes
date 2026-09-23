; Need admin mode to send Win+Shift+Right to move windows across elevated programs like on screen keyboard 
if !A_IsAdmin
{
    MsgBox, 48, Must Run As Admin, Hotfixes.ahk must be ran as an admin to move elevated programs. Attempting to automatically do it now.
    Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"
    ExitApp
}

mouseBackSafetyTrigger := false
mouseForwardSafetyTrigger := false 
isInFastRewindMode := false 

IniRead, longStripReaderTitle, config.ini, LongReaderConfig, LongReaderTitle

; todo - set pixel coords etc to ini https://www.autohotkey.com/docs/v1/lib/IniRead.htm

nudgeMouse() {
    ; Move the mouse all cardinal directions to ensure the mouse cursor moves to trigger the mousemove event for my other scripts (see https://github.com/AlexSchwamle/QOLUserscripts/ auto hide cursor)
    ; right
    MouseMove, 10, 0, 10, R
    MouseMove, -10, 0, 10, R
    ; left 
    MouseMove, -10, 0, 10, R
    MouseMove, 10, 0, 10, R
    ; down 
    MouseMove, 0, 10, 10, R
    MouseMove, 0, -10, 10, R
    ; up 
    MouseMove, 0, -10, 10, R
    MouseMove, 0, 10, 10, R
}

; ==============================================================================
; Combined Mouse Chording (XButton1 + XButton2 = Move Window to Next Monitor)
; ==============================================================================

moveUnderCursorOrActiveWindow() {
    ; Cancel any pending solo timers immediately
    SetTimer setMouseForwardSafetyToFalse, Off
    SetTimer setMouseBackSafetyToFalse, Off
    global mouseForwardSafetyTrigger := false
    global mouseBackSafetyTrigger := false
    global isInFastRewindMode := false
    
    ; Send the native cross-monitor move shortcut
    SendInput, #+{Right}
    
    ; Wait until both buttons are physically released so nothing repeats
    KeyWait, XButton1
    KeyWait, XButton2
}

setMouseBackSafetyToFalse:
    mouseBackSafetyTrigger := false 
    SetTimer setMouseBackSafetyToFalse, Off
return

setMouseForwardSafetyToFalse:
    GetKeyState, mouse4State, XButton2, P

    if (isInFastRewindMode and mouse4State = "D") {
        send {Left}
    } else if (!isInFastRewindMode) {
        send {Right}
        WinGetTitle, curWindowTitle, A
        if (InStr(curWindowTitle, longStripReaderTitle)) {
            sleep, 2000
            nudgeMouse()
        }
    }

    if (mouse4State = "U") {
        mouseForwardSafetyTrigger := false 
        isInFastRewindMode := false 
        SetTimer setMouseForwardSafetyToFalse, Off
    }
return 

$*XButton2::
    ; Check if XButton1 is already held down physically
    if (GetKeyState("XButton1", "P")) {
        moveUnderCursorOrActiveWindow()
        return
    }

    Send {XButton2}
    if (mouseForwardSafetyTrigger) {
        Send {Left}
        mouseForwardSafetyTrigger := false 
        isInFastRewindMode := true 
        SetTimer setMouseForwardSafetyToFalse, 350
        return 
    }
    mouseForwardSafetyTrigger := true 
    isInFastRewindMode := false 
    SetTimer setMouseForwardSafetyToFalse, 350
return

$*XButton1::
    ; Check if XButton2 is already held down physically
    if (GetKeyState("XButton2", "P")) {
        moveUnderCursorOrActiveWindow()
        return
    }

    if (mouseBackSafetyTrigger) {
        send {XButton1}
        mouseBackSafetyTrigger := false 
        return 
    }
    mouseBackSafetyTrigger := true 
    SetTimer setMouseBackSafetyToFalse, 420
return

^!t::
    run cmd.exe, C:\
return

~right & NumpadEnter::
#!s Up::
    TrayTip Sleeping In 5s!, Turning off monitors in 5 seconds...
    sleep 5000
    SendMessage 0x0112, 0xF170, 2,, Program Manager
return

#+D::
    ; Requires https://github.com/AlexSchwamle/PythonBlackMonitorClock
    IniRead, repoPath, config.ini, BlackMonitorConfig, BlackMonitorPythonPath
    run, python %repoPath%
return 

~F5::
    Reload
Return

; Allow quick fullscreen in SumatraPDF without keyboard via middle click 
shouldEnableFullscreenMacro() {
    if (WinActive("ahk_exe ApplicationFrameHost.exe")) ; Acquile Reader 
	return true

    if (!WinActive("ahk_exe SumatraPDF.exe"))
        return false

    MouseGetPos, curX, curY, WinID
    if (curY < 80) ; to still allow closing book tabs with middle click 
        return false 
        
    return WinExist("ahk_exe SumatraPDF.exe ahk_id " . WinID) ; to allow middle clicking taskbars / other windows 
}
#If shouldEnableFullscreenMacro()
    MButton::F11
#If