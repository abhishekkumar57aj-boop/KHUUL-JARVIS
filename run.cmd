@echo off
setlocal
cd /d "%~dp0"

if not exist ".venv\Scripts\python.exe" (
    where python >nul 2>nul
    if not errorlevel 1 (
        python -m venv .venv
    ) else (
        py -3.13 -m venv .venv
        if errorlevel 1 py -3 -m venv .venv
    )
    if errorlevel 1 exit /b 1
)

.venv\Scripts\python.exe -m pip install --upgrade pip
if errorlevel 1 exit /b 1
.venv\Scripts\python.exe -m pip install -r requirements.txt
if errorlevel 1 exit /b 1
.venv\Scripts\python.exe main.py
