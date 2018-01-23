#################################
#               Hi              #
#   Nullsoft Is Great Aint It?  #
# Well, Have Fun Reading Source #            
#################################

RequestExecutionLevel user

!define APP_NAME "Everything Portable"
!define COMP_NAME "MarioMasta64"
!define WEB_SITE "http://github.com/MarioMasta64/EverythingPortable/releases/latest/"
!define VERSION "03.00.00.00"
!define COPYRIGHT ""
!define DESCRIPTION "Application"
!define LICENSE_TXT "D:\launch_everything\doc\everything_license.txt"
!define INSTALLER_NAME "D:\EverythingPortable.exe"
!define MAIN_APP_EXE "launch_everything.bat"
!define INSTALL_TYPE "SetShellVarContext current"

!define REG_START_MENU "Start Menu Folder"

######################################################################

VIProductVersion  "${VERSION}"
VIAddVersionKey "ProductName"  "${APP_NAME}"
VIAddVersionKey "CompanyName"  "${COMP_NAME}"
VIAddVersionKey "LegalCopyright"  "${COPYRIGHT}"
VIAddVersionKey "FileDescription"  "${DESCRIPTION}"
VIAddVersionKey "FileVersion"  "${VERSION}"

######################################################################

SetCompressor ZLIB
Name "${APP_NAME}"
Caption "${APP_NAME}"
OutFile "${INSTALLER_NAME}"
BrandingText "${APP_NAME}"
XPStyle on
InstallDir "$EXEDIR\launch_everything"

######################################################################

!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

!insertmacro MUI_PAGE_WELCOME

!ifdef LICENSE_TXT
!insertmacro MUI_PAGE_LICENSE "${LICENSE_TXT}"
!endif

!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_RUN "$INSTDIR\${MAIN_APP_EXE}"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM

!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

######################################################################

Section -MainProgram
${INSTALL_TYPE}
SetOverwrite ifnewer
SetOutPath "$INSTDIR"
File "D:\launch_everything\launch_everything.bat"
SetOutPath "$INSTDIR\bin"
File "D:\launch_everything\bin\wget.exe"
SetOutPath "$INSTDIR\doc"
File "D:\launch_everything\doc\everything_license.txt"
File "D:\launch_everything\doc\wget_info.txt"
SetOutPath "$INSTDIR\src"
File "D:\launch_everything\src\EverythingPortable.nsi"
SectionEnd

######################################################################

Section -Icons_Reg
SetOutPath "$INSTDIR"
WriteUninstaller "$INSTDIR\uninstall.exe"

!ifdef WEB_SITE
WriteIniStr "$INSTDIR\${APP_NAME}.url" "InternetShortcut" "URL" "${WEB_SITE}"
!endif

SectionEnd

######################################################################

Section Uninstall
${INSTALL_TYPE}
RmDir /r "$INSTDIR"
!ifdef WEB_SITE
Delete "$INSTDIR\${APP_NAME}.url"
!endif

RmDir "$INSTDIR"

SectionEnd

######################################################################

