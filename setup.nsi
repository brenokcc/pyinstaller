Name "Setup!"
Icon "setup.ico"
OutFile "..\Installer.exe"
Function .onInstSuccess
    Exec "pythonw.exe setup.py";
FunctionEnd
Section "Program Files"
 SetAutoClose true
 SetOutPath "$TEMP\Setup"
 CreateDirectory "$TEMP\Setup"
 File /r ".\*"
SectionEnd
