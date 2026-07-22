@echo off
rem Launches PartyGame. Prefers the standalone build; falls back to Godot.
set "GAME_DIR=%~dp0"
set "GAME_DIR=%GAME_DIR:~0,-1%"
if exist "%GAME_DIR%\build\PartyGame.exe" (
    start "" "%GAME_DIR%\build\PartyGame.exe"
    exit /b
)
set "GODOT_EXE=C:\Users\patry\Tools\Godot\Godot_v4.7.1-stable_win64.exe"
if exist "%GODOT_EXE%" (
    start "" "%GODOT_EXE%" --path "%GAME_DIR%"
) else (
    godot --path "%GAME_DIR%"
)
