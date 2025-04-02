@echo off
setlocal EnableDelayedExpansion

REM Get the directory where the script is running
set "DOWNLOAD_DIR=%~dp0"

echo Downloading and installing applications...
cd /d "%DOWNLOAD_DIR%"

REM Ensure PowerShell is available
where powershell >nul 2>nul || (echo PowerShell not found! & exit /b)

REM Define the applications (Name|Download URL|Filename|Install Arguments)
set apps[0]=Steam|https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe|SteamSetup.exe|/S
set apps[1]=Discord|https://discord.com/api/download?platform=win|DiscordSetup.exe|/S
set apps[2]=Chrome|https://dl.google.com/chrome/install/latest/chrome_installer.exe|ChromeSetup.exe|/silent /install

REM Loop through the apps and download/install them
for /L %%i in (0,1,5) do (
	for /F "tokens=1-4 delims=|" %%A in ("!apps[%%i]!") do (
		echo Downloading %%A to %DOWNLOAD_DIR%...
		powershell -Command "& {Invoke-WebRequest -Uri '%%B' -OutFile '%DOWNLOAD_DIR%%%C'}"
		
		if exist "%DOWNLOAD_DIR%%%C" (
			echo Installing %%A...
			start /wait "%DOWNLOAD_DIR%%%C" %%D
		) else (
			echo Failed to download %%A.
		)
	)
)

echo Installation complete! The installers are in %DOWNLOAD_DIR%.
pause