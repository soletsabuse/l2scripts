@echo off
rem PvpPanel - the tray app of PvP focus. Builds it into ..\PvpPanel.exe (Library\PvP).
rem Needs the .NET 10 SDK to build; the .NET 10 desktop runtime to run (the SDK has it). Close PvpPanel before.
cd /d "%~dp0"
dotnet publish PvpPanel.csproj -c Release -o publish
if errorlevel 1 (
  echo Build failed.
  pause
  exit /b 1
)
copy /y publish\PvpPanel.exe ..\PvpPanel.exe >nul
if errorlevel 1 (
  echo ..\PvpPanel.exe is busy - close PvpPanel and run this again.
  pause
  exit /b 1
)
echo Done: %~dp0..\PvpPanel.exe
