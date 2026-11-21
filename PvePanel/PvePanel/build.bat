@echo off
rem PvePanel - the tray app of the PvE farm. Builds it into ..\PvePanel.exe (Library\PvePanel).
rem Needs the .NET 10 SDK to build; the .NET 10 desktop runtime to run (the SDK has it). Close PvePanel before.
cd /d "%~dp0"
dotnet publish PvePanel.csproj -c Release -o publish
if errorlevel 1 (
  echo Build failed.
  pause
  exit /b 1
)
copy /y publish\PvePanel.exe ..\PvePanel.exe >nul
if errorlevel 1 (
  echo ..\PvePanel.exe is busy - close PvePanel and run this again.
  pause
  exit /b 1
)
echo Done: %~dp0..\PvePanel.exe
