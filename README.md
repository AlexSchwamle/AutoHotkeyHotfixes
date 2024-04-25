# AutoHotkeyHotfixes
A simple AutoHotKey (v1) script to do a few quality-of-life tweaks, mainly to require double clicking the mouse back button to go back a page &amp; seeking videos with the front.

I would recommend putting a shortcut to the ahk in the shell:startup folder so it runs on startup.

## Features
- Click the mouse forward button to seek forward in videos, or hold it to continuously seek forward.
- Double click the mouse forward button to seek backwards in videos, or hold it to continuously seek backwards.
    - Note that these two features use the left and right arrow keys, so those need to work for it to work.
- The mouse back button won't be sent unless you double click it, to prevent accidentally backing out of a page.
- If you press ctrl + alt + t it will open cmd.exe in C:\ 
- If you press either of these two combinations it will turn your monitors off like sleep mode, but it will not put your computer to sleep.
    - Right arrow + Numpad enter
    - Windows key + alt + s
- I use a triangular monitor setup, so I use a hotkey to open up 2 windows of Brave on [blackscreen.app](https://blackscreen.app/) and then Edge browser on [OnlineClock.net](https://onlineclock.net/), setting them to fullscreen & dark so I can use them as a clock and a black screen. Edge is because I use split tunneling for my VPN since OnlineClock hates VPNs for some reason.
    - Windows key + Shift + D