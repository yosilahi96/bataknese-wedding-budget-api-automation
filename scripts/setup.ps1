$ErrorActionPreference = "Stop"

$rubyBin = "C:\Ruby40-x64\bin"
$env:Path = "$rubyBin;$env:Path"
$env:BUNDLE_USER_HOME = "$PSScriptRoot\..\tmp\bundle"
$env:BUNDLE_PATH = "$PSScriptRoot\..\vendor\bundle"

& "$rubyBin\bundle.bat" config set --local path vendor/bundle
& "$rubyBin\bundle.bat" install
