@echo off
rem PvP focus server: the page http://127.0.0.1:7790 and the live link to the bots. Started with no window;
rem a second start does nothing (the server runs already). Its log: pvp_server.log
cd /d "%~dp0"
start "" pythonw "%~dp0pvp_server.py"
start "" http://127.0.0.1:7790/
