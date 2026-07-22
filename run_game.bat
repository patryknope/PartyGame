@echo off
rem Launches PartyGame with a local Godot 4 binary.
set "GAME_DIR=%~dp0"
set "GAME_DIR=%GAME_DIR:~0,-1%"
set "GODOT_EXE=C:\Users\patry\Tools\Godot\Godot_v4.7.1-stable_win64.exe"
if exist "%GODOT_EXE%" (
    start "" "%GODOT_EXE%" --path "%GAME_DIR%"
) else (
    godot --path "%GAME_DIR%"
)
