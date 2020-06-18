$versionPrefix = Read-Host "Please input version number"
$paths = Get-ChildItem -Recurse -Depth 2 -Include *.csproj -Name
foreach ($path in $paths)
{
	$proj = [xml](get-content (Resolve-Path $path))
	$proj.GetElementsByTagName("VersionPrefix") | foreach {
    $_."#text" = "$versionPrefix"
}
$proj.Save((Resolve-Path $path))
}