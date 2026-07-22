@echo off
rem Launches PartyGame with a local Godot 4 binary.
set GODOT_EXE=C:\Users\patry\Tools\Godot\Godot_v4.7.1-stable_win64.exe
if exist "%GODOT_EXE%" (
    "%GODOT_EXE%" --path "%~dp0"
) else (
    godot --path "%~dp0"
)
