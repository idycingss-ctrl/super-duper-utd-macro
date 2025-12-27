@echo off
cd /d "%~dp0"

:: 1. Check if we need to Install or Update
if exist ".git" (
    echo Updating Macro...
    git fetch --all
    git reset --hard origin/main
) else (
    echo Downloading Macro for the first time...
    :: Clone to a temp folder first to avoid errors
    git clone https://github.com/idycingss-ctrl/super-duper-utd-macro.git temp_repo
    
    :: Move all files from temp_repo to here
    xcopy /E /Y "temp_repo\*" .
    
    :: Delete the temp folder
    rmdir /s /q "temp_repo"
)

:: 2. Run the macro
echo Starting GameMacro...
start "" "GameMacro.ahk"