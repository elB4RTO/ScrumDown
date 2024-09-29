
@ECHO off

ECHO :::: Initializing

:: Check development environment

where /Q qmake6
IF "%ERRORLEVEL%" NEQ "0" (
    ECHO:
    ECHO QMake not found, please add the Qt binaries to your path
    PAUSE
    EXIT /B 1
)

where /Q cl
IF "%ERRORLEVEL%" NEQ "0" GOTO :environment_error

where /Q nmake
IF "%ERRORLEVEL%" EQU "0" GOTO :check_priviledges

where /Q jom
IF "%ERRORLEVEL%" NEQ "0" GOTO :check_priviledges

:environment_error

ECHO:
ECHO Missing commands, please run this script within a development environment
PAUSE
EXIT /B 1

:check_priviledges

:: Check Administrator priviledges

net session >nul 2>nul
IF "%ERRORLEVEL%" NEQ "0" (
    ECHO:
    ECHO Missing priviledges, please run this script as Administrator
    PAUSE
    EXIT /B 1
)

:: Store the current path

FOR /F "tokens=* USEBACKQ" %%e IN (`cd`) DO SET current_path=%%e

:: Setup helper variables for the paths

SET scripts_path=%~dp0
SET project_root=%scripts_path%\..
SET build_path=%project_root%\build
SET source_path=%project_root%\scrumdown
SET resources_path=%project_root%\resources
SET application_path=%USERPROFILE%\AppData\Local\ScrumDown
SET desktop_path=%USERPROFILE%\Desktop

:: Move into the root project folder

cd %project_root%

:: Create a build folder and step into

IF EXIST "%build_path%" rmdir /S /Q "%build_path%"
mkdir "%build_path%"
cd "%build_path%"

:: Prepare the build files
ECHO :::: Preparing build files

SET DESKTOP_ENVIRONMENT=windows
qmake6 "%source_path%" -config release

IF "%ERRORLEVEL%" NEQ "0" (
    ECHO:
    ECHO Failed to prepare build files
    cd %current_path%
    PAUSE
    EXIT /B 1
)

:: Build the project
ECHO :::: Building project

where /Q nmake
IF "%ERRORLEVEL%" NEQ "0" GOTO :compile_with_jom

nmake
IF "%ERRORLEVEL%" EQU "0" GOTO :build_succeeded
GOTO :build_failed

:compile_with_jom

where /Q jom
IF "%ERRORLEVEL%" NEQ "0" GOTO :build_failed

jom
IF "%ERRORLEVEL%" EQU "0" GOTO :build_succeeded

:build_failed

ECHO:
ECHO Failed to build project
cd %current_path%
PAUSE
EXIT /B 1

:build_succeeded

:: Prepare the application folder

mkdir "%build_path%\ScrumDown"

copy /V /Y "%build_path%\release\scrumdown.exe" "%build_path%\ScrumDown\ScrumDown.exe"

:: Check if libraries need to be deployed

IF "%1" NEQ "-libs" GOTO :skip_libraries

:: Deploy the Qt libraries
ECHO :::: Deploying Qt libraries

windeployqt6 --release --no-translations --qmldir "%source_path%" "%build_path%\ScrumDown\ScrumDown.exe"
IF "%ERRORLEVEL%" NEQ "0" (
    ECHO:
    ECHO Failed to deploy libraries
    cd %current_path%
    PAUSE
    EXIT /B 1
)

:skip_libraries

:: Deploy the resources
ECHO :::: Deploying resources

copy /V /Y "%resources_path%\ScrumDown.png" "%build_path%\ScrumDown\ScrumDown.png"
IF "%ERRORLEVEL%" NEQ "0" (
    ECHO:
    ECHO Failed to deploy resources
    cd %current_path%
    PAUSE
    EXIT /B 1
)

:: Install the application
ECHO :::: Installing application in: %application_path%

IF EXIST "%application_path%" rmdir /S /Q "%application_path%"
mkdir "%application_path%"

xcopy /E /Y /F "%build_path%\ScrumDown" "%application_path%\"
IF "%ERRORLEVEL%" NEQ "0" (
    ECHO:
    ECHO Failed to copy executable
    cd %current_path%
    PAUSE
    EXIT /B 1
)

:: Create a link on the Desktop
ECHO :::: Creating desktop link

IF EXIST "%desktop_path%\ScrumDown.exe" del "%desktop_path%\ScrumDown.exe"
mklink "%desktop_path%\ScrumDown.exe" "%application_path%\ScrumDown.exe"
IF "%ERRORLEVEL%" NEQ "0" (
    ECHO:
    ECHO Failed to create desktop link
    cd %current_path%
    PAUSE
    EXIT /B 1
)

:: Installation finished
ECHO:
ECHO :::: Installation completed
cd %current_path%
PAUSE
