

mouseBackSafetyTrigger := false
mouseForwardSafetyTrigger := false 
isInFastRewindMode := false 

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

openBrowser(which) {
    send #r
    sleep 100
    send {LWin up}
    sleep 100 
    send %which%
    sleep 100
    send {Enter}
    sleep 500
}
typeURL(url) {
    send !d 
    sleep 100
    send %url%
    send {enter}
}

clickAbsoluteThenWindow(x, y, windowX, windowY, numClicks, speed) {
    CoordMode, Mouse, Screen 
    MouseClick, Left, x, y, 1, 5
    CoordMode, Mouse, Window
    MouseClick, Left, windowX, windowY, numClicks, speed
}

#+D::
    ; I use my right monitor for the clock so left and upper monitor are brave
    openBrowser("brave")
    WinWait New Tab - Brave
    WinActivate
    WinRestore
    WinMove, -1650, 200
    WinMaximize
    typeURL("blackscreen.app")

    openBrowser("brave")
    WinWait New Tab - Brave
    WinActivate
    WinRestore
    WinMove,,, -640, -850, 800, 600
    WinMaximize
    typeURL("blackscreen.app")

    openBrowser("msedge")
    WinWait, ahk_exe msedge.exe
    WinActivate
    WinRestore
    WinMove, 300, 200
    WinMaximize
    typeURL("onlineclock.net")
    
    clickAbsoluteThenWindow(-1650, 200, 905, 571, 2, 2)
    clickAbsoluteThenWindow(-640, -850, 905, 571, 2, 2)

    clickAbsoluteThenWindow(300, 200, 641, 584, 1, 2)
    MouseClick, Left, 61, 127,1,2
    MouseClick, Left, 239, 127,1,2
    MouseClick, Left, 959, 512,1,2
return 

~F5::
    Reload
Return