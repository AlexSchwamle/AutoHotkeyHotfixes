import pynput
import time
import threading
import pyautogui
import socket
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

class Socket:
    def __init__(self):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.bind(("localhost", 11235))
        self.sock.listen(1)

    def startServer(self):
        while True:
            conn, addr = self.sock.accept()
            data = conn.recv(8)

            print("read", data)

            XButton1()
            conn.close()

def setSafetyToFalse():
    global safetyTrigger
    safetyTrigger = False 
    timer.stop()

def sendKey(key):
    print("debug", safetyTrigger)

    pyautogui.hotkey("alt", "left")

    #mouseCtl.press(pynput.mouse.Button.button8)
    #mouseCtl.release(pynput.mouse.Button.button8)

def XButton1():
    global safetyTrigger
    if safetyTrigger:
        sendKey("XButton1")
        safetyTrigger = False
        timer.stop()
        return
    safetyTrigger = True
    timer.start(setSafetyToFalse, 0.420)

safetyTrigger = False

sock = Socket()
timer = Timer()
mouseCtl = pynput.mouse.Controller()

#try:
sock.startServer()
#except KeyboardInterrupt:
#    pass
#finally:
print("Script ended!")                                                                                                                                                                                             