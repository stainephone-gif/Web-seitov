@echo off
rem Machine of Consent - launcher for Windows 7/10/11
rem Starts server.py and opens the site in kiosk mode.
setlocal
cd /d "%~dp0"

rem ---- find Python (Windows 7: Python 3.8.x is the last supported version) ----
set "PY="
if exist "%~dp0python\python.exe" set "PY=%~dp0python\python.exe"
if not defined PY where py >nul 2>&1 && set "PY=py -3"
if not defined PY where python >nul 2>&1 && set "PY=python"
if not defined PY if exist "%LocalAppData%\Programs\Python\Python38\python.exe" set "PY=%LocalAppData%\Programs\Python\Python38\python.exe"
if not defined PY if exist "%LocalAppData%\Programs\Python\Python38-32\python.exe" set "PY=%LocalAppData%\Programs\Python\Python38-32\python.exe"
if not defined PY if exist "C:\Python38\python.exe" set "PY=C:\Python38\python.exe"
if not defined PY if exist "%ProgramFiles%\Python38\python.exe" set "PY=%ProgramFiles%\Python38\python.exe"
if not defined PY if exist "%ProgramFiles(x86)%\Python38-32\python.exe" set "PY=%ProgramFiles(x86)%\Python38-32\python.exe"

if not defined PY (
  echo Python not found.
  echo Install Python 3.8.10 ^(last version for Windows 7^) and tick "Add Python to PATH".
  pause
  exit /b 1
)

rem ---- start server in its own window ----
if "%PY%"=="py -3" (
  start "Machine of Consent server" py -3 "%~dp0server.py"
) else (
  start "Machine of Consent server" "%PY%" "%~dp0server.py"
)

rem wait for the server (ping is used as a delay: works everywhere, unlike timeout in some shells)
ping -n 4 127.0.0.1 >nul

set "URL=http://localhost:8000/"

rem ---- find browser: Chrome 109 / Firefox 115 ESR are the last for Windows 7 ----
set "CHROME="
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not defined CHROME if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "CHROME=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if not defined CHROME if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" set "CHROME=%LocalAppData%\Google\Chrome\Application\chrome.exe"
if defined CHROME (
  start "" "%CHROME%" --kiosk --autoplay-policy=no-user-gesture-required --disable-session-crashed-bubble --noerrdialogs "%URL%"
  exit /b 0
)

set "FIREFOX="
if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" set "FIREFOX=%ProgramFiles%\Mozilla Firefox\firefox.exe"
if not defined FIREFOX if exist "%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe" set "FIREFOX=%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe"
if defined FIREFOX (
  start "" "%FIREFOX%" -kiosk "%URL%"
  exit /b 0
)

rem fallback: default browser
start "" "%URL%"
exit /b 0
