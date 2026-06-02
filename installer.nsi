; RustDesk Windows Installer Script
; This script creates an EXE installer for RustDesk

!include "MUI2.nsh"
!include "x64.nsh"

; Basic settings
Name "RustDesk"
OutFile "RustDesk-Setup-${VERSION}.exe"
InstallDir "$PROGRAMFILES\RustDesk"
InstallDirRegKey HKLM "Software\RustDesk" "Install_Dir"

; Version information
VIProductVersion "1.0.0.0"
VIAddVersionKey "ProductName" "RustDesk"
VIAddVersionKey "FileVersion" "1.0.0.0"
VIAddVersionKey "ProductVersion" "1.0.0.0"

; MUI2 settings
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "English"

; Installer section
Section "Install"
  SetOutPath "$INSTDIR"
  
  ; Copy executable from Flutter build output
  File "flutter\build\windows\x64\runner\Release\*.exe"
  File "flutter\build\windows\x64\runner\Release\*.dll"
  
  ; Create start menu shortcuts
  CreateDirectory "$SMPROGRAMS\RustDesk"
  CreateShortCut "$SMPROGRAMS\RustDesk\RustDesk.lnk" "$INSTDIR\flutter_hbb.exe"
  CreateShortCut "$SMPROGRAMS\RustDesk\Uninstall.lnk" "$INSTDIR\uninstall.exe"
  
  ; Create uninstaller
  WriteUninstaller "$INSTDIR\uninstall.exe"
  
  ; Write registry keys
  WriteRegStr HKLM "Software\RustDesk" "Install_Dir" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RustDesk" "DisplayName" "RustDesk"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RustDesk" "UninstallString" "$INSTDIR\uninstall.exe"
SectionEnd

; Uninstaller section
Section "Uninstall"
  RMDir /r "$SMPROGRAMS\RustDesk"
  RMDir /r "$INSTDIR"
  DeleteRegKey HKLM "Software\RustDesk"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RustDesk"
SectionEnd
