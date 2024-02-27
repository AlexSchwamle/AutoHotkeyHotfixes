import pynput
import time
import threading
import pyautogui
from pynput.mouse import Button
from pynput.keyboard import Key 

class Timer:
    def __init__(self):
        self.timer = None

    def start(self, callback, timerTime):
        if self.timer:
            self.timer.cancel()
        self.timer = threading.Timer(timerTime, callback)
        self.timer.start()

    def stop(self):
        if self.timer:
            self.timer.cancel()
            self.timer = None 

class MouseState:
    def __init__(self):
        self.mouseForwardIsDown = False 

    def changeMouseForward(self, state):
        self.mouseForwardIsDown = state 

    def get(self):
        if self.mouseForwardIsDown:
            return "D"
        else:
            return "U"

def sendKey(key):
    pyautogui.press(key)

def handleXButton2():
    global safetyTrigger
    global isInFastRewindMode

    #mouseCtl.press(Button.button9)
    #mouseCtl.release(Button.button9)

    if safetyTrigger:
        sendKey("Left")
        safetyTrigger = False
        isInFastRewindMode = True
        timer.start(setSafetyToFalse, 0.350)
        return
    safetyTrigger = True
    isInFastRewindMode = False
    timer.start(setSafetyToFalse, 0.350)

def setSafetyToFalse():
    global safetyTrigger
    global isInFastRewindMode

    mouse4State = mouseState.get()
    if isInFastRewindMode and mouse4State == "D":
        sendKey("Left")
    elif not isInFastRewindMode:
        sendKey("Right")

    if mouse4State == "U":
        safetyTrigger = False
        isInFastRewindMode = False
        timer.stop()
    else:
        timer.start(setSafetyToFalse, 0.350)

def mouseClickCallback(x, y, button, state):
    if button == Button.button9:
        mouseState.changeMouseForward(state)
        if mouseState.get() == "D":
            handleXButton2()

safetyTrigger = False
isInFastRewindMode = False

timer = Timer()
listener = pynput.mouse.Listener(on_click=mouseClickCallback)

mouseState = MouseState()
mouseCtl = pynput.mouse.Controller()
keyboardCtl = pynput.keyboard.Controller()

try:
    listener.start()
    listener.join()
except KeyboardInterrupt:
    pass
finally:
    print("Script ended!")

