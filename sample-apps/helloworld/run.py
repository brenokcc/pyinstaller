from sys import platform
from os import system
import ctypes

if platform == "linux" or platform == "linux2":
    pass
elif platform == "darwin":
    system('osascript -e \'display dialog "Hello World!" buttons {"OK"}\'')
elif platform == "win32":
    ctypes.windll.user32.MessageBoxW(None, u"Hello World!", u"Alert", 0)