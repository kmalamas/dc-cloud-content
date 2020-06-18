#!/bin/bash

set -e

buildDir=".build" && mkdir -p $buildDir
cacheDir="$HOME/.local/share" && mkdir -p $cacheDir

# NuGet
nugetPath="$buildDir/nuget.exe"
nugetVersion="latest"
cacheNuget="$cacheDir/nuget.$nugetVersion.exe"
nugetUrl="https://dist.nuget.org/win-x86-commandline/$nugetVersion/nuget.exe"
if [ ! -f $nugetPath ]; then
	if [ ! -f $cacheNuget ]; then
		wget -O $cacheNuget $nugetUrl 2>/dev/null || curl -o $cacheNuget --location $nugetUrl /dev/null
	fi
	cp $cacheNuget $nugetPath
fi

# Vendo Build Tools
packagesDir="packages"
buildToolsNupkg="Touchtech.Vendo.BuildTools.AspNetCore"
buildToolsDir="$packagesDir/$buildToolsNupkg"
if [ ! -d $buildToolsDir ]; then
	if [ ! -z "$VENDO_BUILDTOOLS_VERSION" ]; then
		echo "*** Using explicit Vendo Build Tools version '$VENDO_BUILDTOOLS_VERSION'"
		mono $nugetPath install $buildToolsNupkg -Version $VENDO_BUILDTOOLS_VERSION -ExcludeVersion -o $packagesDir -nocache -pre
	else
		mono $nugetPath install $buildToolsNupkg -ExcludeVersion -o $packagesDir -nocache -pre
	fi
fi

buildScriptPath="$buildToolsDir/build/build.sh"
chmod u+x $buildScriptPath
. $buildScriptPath "$@"
