@echo off
rem Builds dist\server.exe that runs on Windows 7.
rem Must be run on a machine with Python 3.8.x (newer Python builds do not start on Windows 7).
cd /d "%~dp0"
py -3.8 -m pip install "pyinstaller==5.13.2"
py -3.8 -m PyInstaller --noconfirm server.spec
echo.
echo Done: dist\server.exe
pause
