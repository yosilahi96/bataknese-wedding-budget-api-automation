@echo off
set "RUBY_BIN=C:\Ruby40-x64\bin"
set "PATH=%RUBY_BIN%;%PATH%"
set "BUNDLE_USER_HOME=%~dp0tmp\bundle"
set "BUNDLE_PATH=%~dp0vendor\bundle"
set "RUBYLIB=%~dp0support\ruby_overrides;%RUBYLIB%"

"%RUBY_BIN%\bundle.bat" exec cucumber -p api
