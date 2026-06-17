$ErrorActionPreference = "Stop"

$rubyBin = "C:\Ruby40-x64\bin"
$env:Path = "$rubyBin;$env:Path"
$env:BUNDLE_USER_HOME = "$PSScriptRoot\..\tmp\bundle"
$env:BUNDLE_PATH = "$PSScriptRoot\..\vendor\bundle"
$env:RUBYLIB = "$PSScriptRoot\..\support\ruby_overrides;$env:RUBYLIB"

& "$rubyBin\bundle.bat" exec cucumber --tags "@login"
