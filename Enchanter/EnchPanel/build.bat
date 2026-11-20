@echo off
rem EnchPanel - the tray app of the enchanter. Builds it into ..\EnchPanel.exe (Library\Enchanter).
rem Needs the .NET 10 SDK to build; the .NET 10 desktop runtime to run (the SDK has it). Close EnchPanel before.
cd /d "%~dp0"
dotnet publish EnchPanel.csproj -c Release -o publish
if errorlevel 1 (
  echo Build failed.
  pause
  exit /b 1
)
copy /y publish\EnchPanel.exe ..\EnchPanel.exe >nul
if errorlevel 1 (
  echo ..\EnchPanel.exe is busy - close EnchPanel and run this again.
  pause
  exit /b 1
)
echo Done: %~dp0..\EnchPanel.exe
