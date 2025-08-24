; uget NSIS Installer Script
; Creates a Windows executable installer for uget

;--------------------------------
; Include Modern UI
!include "MUI2.nsh"

; Include EnvVarUpdate if available (optional)
!ifdef INCLUDE_ENVVARUPDATE
!include "EnvVarUpdate.nsh"
!endif

;--------------------------------
; General
Name "uget"
OutFile "uget-installer.exe"
Unicode True

; Default installation folder
InstallDir "$PROGRAMFILES\uget"

; Get installation folder from registry if available
InstallDirRegKey HKCU "Software\uget" ""

; Request application privileges for Windows Vista+
RequestExecutionLevel admin

;--------------------------------
; Variables
Var StartMenuFolder

;--------------------------------
; Interface Configuration
!define MUI_ABORTWARNING
!define MUI_ICON "uget.ico"
!define MUI_UNICON "uget.ico"

; Welcome page
!define MUI_WELCOMEPAGE_TITLE "Welcome to the uget Setup Wizard"
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of uget, an enhanced interface for Windows Package Manager (winget).$\r$\n$\r$\nIt is recommended that you close all other applications before starting Setup. This will make it possible to update relevant system files without having to reboot your computer.$\r$\n$\r$\nClick Next to continue."

; License page
!define MUI_LICENSEPAGE_TEXT_TOP "Please review the license terms before installing uget."
!define MUI_LICENSEPAGE_TEXT_BOTTOM "If you accept the terms of the agreement, click I Agree to continue. You must accept the agreement to install uget."

; Components page
!define MUI_COMPONENTSPAGE_TEXT_TOP "Select the components to install."

; Directory page
!define MUI_DIRECTORYPAGE_TEXT_TOP "Setup will install uget in the following folder. To install in a different folder, click Browse and select another folder. Click Next to continue."

; Start Menu page
!define MUI_STARTMENUPAGE_TEXT_TOP "Select the Start Menu folder in which you would like Setup to create the program's shortcuts."
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "uget"

; Installation page
!define MUI_INSTFILESPAGE_FINISHHEADER_TEXT "Installation Complete"
!define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT "uget has been successfully installed on your computer."

; Finish page
!define MUI_FINISHPAGE_TITLE "Completing the uget Setup Wizard"
!define MUI_FINISHPAGE_TEXT "uget has been installed on your computer.$\r$\n$\r$\nClick Finish to close this wizard."
!define MUI_FINISHPAGE_RUN "$INSTDIR\uget.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Show uget help"
!define MUI_FINISHPAGE_RUN_PARAMETERS "--help"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\README.txt"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Show README"

;--------------------------------
; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "License.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Languages
!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Installer Sections

Section "uget (required)" SecMain
  SectionIn RO
  
  ; Set output path to the installation directory
  SetOutPath $INSTDIR
  
  ; Install files
  File "uget.exe"
  File "License.txt"
  File "README.txt"
  
  ; Store installation folder
  WriteRegStr HKCU "Software\uget" "" $INSTDIR
  
  ; Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  
  ; Add to Add/Remove Programs
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\uget" "DisplayName" "uget"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\uget" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\uget" "QuietUninstallString" "$INSTDIR\Uninstall.exe /S"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\uget" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\uget" "DisplayIcon" "$INSTDIR\uget.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\uget" "Publisher" "uget Project"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\uget" "HelpLink" "https://github.com/Utsav-56/uget"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\uget" "URLInfoAbout" "https://github.com/Utsav-56/uget"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\uget" "DisplayVersion" "1.0.0"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\uget" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\uget" "NoRepair" 1
  
SectionEnd

Section "Add to PATH" SecPath
  ; Add installation directory to PATH
  !ifdef INCLUDE_ENVVARUPDATE
    ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR"
  !else
    ; Alternative PATH update method using WriteRegStr
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "PATH" "%PATH%;$INSTDIR"
    ; Broadcast environment change
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
  !endif
SectionEnd

Section "Start Menu Shortcuts" SecStartMenu
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    
    ; Create shortcuts
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
    CreateShortcut "$SMPROGRAMS\$StartMenuFolder\uget.lnk" "$INSTDIR\uget.exe" "--help"
    CreateShortcut "$SMPROGRAMS\$StartMenuFolder\uget Command Prompt.lnk" "cmd.exe" "/k cd /d $\"$INSTDIR$\" && echo uget is ready! Type 'uget --help' to get started."
    CreateShortcut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
  
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section "Desktop Shortcut" SecDesktop
  CreateShortcut "$DESKTOP\uget.lnk" "$INSTDIR\uget.exe" "--help"
SectionEnd

;--------------------------------
; Descriptions

; Language strings
LangString DESC_SecMain ${LANG_ENGLISH} "Main uget application files (required)"
LangString DESC_SecPath ${LANG_ENGLISH} "Add uget to the system PATH so you can run it from anywhere"
LangString DESC_SecStartMenu ${LANG_ENGLISH} "Create Start Menu shortcuts for easy access"
LangString DESC_SecDesktop ${LANG_ENGLISH} "Create a desktop shortcut"

; Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecMain} $(DESC_SecMain)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPath} $(DESC_SecPath)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenu} $(DESC_SecStartMenu)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop} $(DESC_SecDesktop)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
; Uninstaller Section

Section "Uninstall"
  ; Remove from PATH
  !ifdef INCLUDE_ENVVARUPDATE
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR"
  !else
    ; Basic PATH removal (manual registry cleanup may be needed)
    ; This is a simplified approach - for production consider a more robust solution
    DetailPrint "Note: PATH cleanup requires manual intervention without EnvVarUpdate plugin"
  !endif
  
  ; Remove files and uninstaller
  Delete "$INSTDIR\uget.exe"
  Delete "$INSTDIR\License.txt"
  Delete "$INSTDIR\README.txt"
  Delete "$INSTDIR\Uninstall.exe"
  
  ; Remove directories
  RMDir "$INSTDIR"
  
  ; Remove shortcuts
  !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
  Delete "$SMPROGRAMS\$StartMenuFolder\uget.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\uget Command Prompt.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"
  RMDir "$SMPROGRAMS\$StartMenuFolder"
  Delete "$DESKTOP\uget.lnk"
  
  ; Remove registry keys
  DeleteRegKey HKCU "Software\uget"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\uget"
SectionEnd

;--------------------------------
; Functions

Function .onInit
  ; Check if already installed
  ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\uget" "UninstallString"
  StrCmp $R0 "" done
  
  MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
  "uget is already installed. $\n$\nClick 'OK' to remove the previous version or 'Cancel' to cancel this upgrade." \
  IDOK uninst
  Abort
  
  uninst:
    ClearErrors
    ExecWait '$R0 /S _?=$INSTDIR'
    
    IfErrors no_remove_uninstaller done
      Delete $R0
      RMDir $INSTDIR
    no_remove_uninstaller:
  
  done:
FunctionEnd

Function .onInstSuccess
  ; Create README file
  FileOpen $0 "$INSTDIR\README.txt" w
  FileWrite $0 "uget - Enhanced Windows Package Manager Interface$\r$\n"
  FileWrite $0 "================================================$\r$\n$\r$\n"
  FileWrite $0 "Thank you for installing uget!$\r$\n$\r$\n"
  FileWrite $0 "Quick Start:$\r$\n"
  FileWrite $0 "  uget --help          # Show help$\r$\n"
  FileWrite $0 "  uget si chrome       # Search and install Chrome$\r$\n"
  FileWrite $0 "  uget install firefox # Install Firefox directly$\r$\n"
  FileWrite $0 "  uget upgrade         # Upgrade all packages$\r$\n$\r$\n"
  FileWrite $0 "Documentation: https://github.com/Utsav-56/uget$\r$\n"
  FileWrite $0 "Issues: https://github.com/Utsav-56/uget/issues$\r$\n"
  FileClose $0
FunctionEnd

;--------------------------------
; Command Line Support

Function .onInitCmdLine
  ; Check for silent install flag
  ${GetParameters} $0
  ClearErrors
  ${GetOptions} $0 "/S" $1
  IfErrors +2 0
    SetSilent silent
  
  ; Check for custom install directory
  ClearErrors
  ${GetOptions} $0 "/D=" $1
  IfErrors +2 0
    StrCpy $INSTDIR $1
FunctionEnd
