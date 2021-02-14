"""
import win32api, win32con
import time
import random

while True:
    x = int(random.random() * 480)
    y = int(random.random() * 480)
    win32api.SetCursorPos((x, y))
    time.sleep(2)
"""
import sys
import ctypes
import time

mouse_event = ctypes.windll.user32.mouse_event
MOUSEEVENTF_MOVE = 0x0001

total_time = 1000 * 1000
if len(sys.argv) > 1:
    total_time = int(sys.argv[1])

while total_time > 0:
    mouse_event(MOUSEEVENTF_MOVE, 0, 0, 0, 0)
    time.sleep(60)#sleep for 60 seconds
    total_time -= 1
