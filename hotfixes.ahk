mouseBackSafetyTrigger := false
mouseForwardSafetyTrigger := false 
isInFastRewindMode := false 

; todo - set pixel coords etc to ini https://www.autohotkey.com/docs/v1/lib/IniRead.htm

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
    }

    if (mouse4State = "U") {
        mouseForwardSafetyTrigger := false 
        isInFastRewindMode := false 
        SetTimer setMouseForwardSafetyToFalse, Off
    }
return 

$xbutton2::
    send {XButton2}
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


XButton1::
    if (mouseBackSafetyTrigger) {
        send {XButton1}
        mouseBackSafetyTrigger := false 
        return 
    }
    mouseBackSafetyTrigger := true 
    SetTimer setMouseBackSafetyToFalse, 420
Return

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
    msgbox %repoPath%
    run, python %repoPath%
return 

~F5::
    Reload
Return