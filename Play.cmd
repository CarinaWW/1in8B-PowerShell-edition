@echo off
setlocal
set "gameLang=%~1"
if not defined gameLang set "gameLang=en"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp01in8b.ps1" -Lang "%gameLang%"
