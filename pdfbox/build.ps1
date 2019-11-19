$project_version = "2.0.18";
$bin_dir_name = "dlls"
$bin_dir = ".\target\$($bin_dir_name)"
$ikvm_dir = "path to IKVM home"
$ikvmc = "$($ikvm_dir)/bin/ikvmc.exe"

Write-Host "Creating output folder"
if (Test-Path $bin_dir)
{
    Remove-Item -Recurse -Force $bin_dir
}
New-Item -Path ".\target" -Name $bin_dir_name -ItemType "directory"

$common_refs = @(
    "-reference:$($ikvm_dir)/bin/IKVM.OpenJDK.Util.dll",
    "-reference:$($ikvm_dir)/bin/IKVM.OpenJDK.Charsets.dll",
    "-reference:$($ikvm_dir)/bin/IKVM.OpenJDK.Text.dll",
    "-reference:$($ikvm_dir)/bin/IKVM.OpenJDK.Core.dll",
    "-reference:$($ikvm_dir)/bin/IKVM.OpenJDK.Media.dll",
    "-reference:$($ikvm_dir)/bin/IKVM.OpenJDK.Misc.dll",
    "-reference:$($ikvm_dir)/bin/IKVM.OpenJDK.Security.dll"
)

Write-Host "Building Hamcrest"
$hamcrest_jar = ".\target\dependency\hamcrest-core-1.3.jar"
$hamcrest_args = [array]$common_refs + @(
    "-target:library",
    "-compressresources",
    "-out:$($bin_dir)\hamcrest.dll",
    "$($hamcrest_jar)"
)
& $ikvmc $hamcrest_args

Write-Host "Building JUnit"
$junit_jar = ".\target\dependency\junit-4.12.jar"
$junit_args = [array]$common_refs + @(
    "-reference:$($bin_dir)/hamcrest.dll",
    "-target:library",
    "-compressresources",
    "-out:$($bin_dir)\junit.dll",
    "$($junit_jar)"
)
& $ikvmc $junit_args

Write-Host "Building BC Prov"
$bcprov_jar = ".\target\dependency\bcprov-jdk15on-1.60.jar"
$bcprov_args = [array]$common_refs + @(
    "-reference:$($bin_dir)/junit.dll",
    "-target:library",
    "-compressresources",
    "-out:$($bin_dir)\bcprov.dll",
    "$($bcprov_jar)"
)
& $ikvmc $bcprov_args

Write-Host "Building BC Mail"
$bcmail_jar = ".\target\dependency\bcmail-jdk15on-1.60.jar"
$bcmail_args = [array]$common_refs + @(
    "-reference:$($bin_dir)/junit.dll",
    "-target:library",
    "-compressresources",
    "-out:$($bin_dir)\bcmail.dll",
    "$($bcmail_jar)"
)
& $ikvmc $bcmail_args

Write-Host "Building BC PKIX"
$bcpkix_jar = ".\target\dependency\bcpkix-jdk15on-1.60.jar"
$bcpkix_args = [array]$common_refs + @(
    "-reference:$($bin_dir)/junit.dll",
    "-target:library",
    "-compressresources",
    "-out:$($bin_dir)\bcpkix.dll",
    "$($bcpkix_jar)"
)
& $ikvmc $bcpkix_args

Write-Host "Building Commons Logging"
$logging_jar = ".\target\dependency\commons-logging-1.2.jar"
$logging_args = [array]$common_refs + @(
    "-reference:$($ikvm_dir)/bin/IKVM.AWT.WinForms.dll",
    "-reference:$($ikvm_dir)/bin/IKVM.OpenJDK.SwingAWT.dll",    
    "-target:library",
    "-compressresources",
    "-out:$($bin_dir)\commons-logging.dll",
    "$($logging_jar)"
)
& $ikvmc $logging_args

Write-Host "Building FontBox"
$fontbox_jar = ".\target\dependency\fontbox-$($project_version)-SNAPSHOT.jar"
$fontbox_args = [array]$common_refs + @(
    "-reference:$($bin_dir)/commons-logging.dll",
    "-reference:$($bin_dir)/junit.dll",
    "-target:library",
    "-compressresources",
    "-version:${project_version}.0",
    "-out:$($bin_dir)\fontbox-$($project_version).dll",
    "$($fontbox_jar)"
)
& $ikvmc $fontbox_args

Write-Host "Building PDFBox"
$pdfbox_jar = ".\target\pdfbox-$($project_version)-SNAPSHOT.jar"
$pdfbox_args = [array]$common_refs + @(
    "-reference:$($ikvm_dir)/bin/IKVM.AWT.WinForms.dll",
    "-reference:$($ikvm_dir)/bin/IKVM.OpenJDK.SwingAWT.dll",    
    "-reference:$($bin_dir)/fontbox-$($project_version).dll",
    "-reference:$($bin_dir)/bcprov.dll",
    "-reference:$($bin_dir)/bcmail.dll",
    "-reference:$($bin_dir)/bcpkix.dll",
    "-reference:$($bin_dir)/junit.dll",
    "-reference:$($bin_dir)/commons-logging.dll",
    "-target:library",
    "-compressresources",
    "-version:${project_version}.0",
    "-out:$($bin_dir)\pdfbox-$($project_version).dll",
    "$($pdfbox_jar)"
)
& $ikvmc $pdfbox_args

Write-Host "Copying IKVM dependencies"
$ikvm_files = @(
    "$($ikvm_dir)/bin/IKVM.Runtime.dll",
    "$($ikvm_dir)/bin/IKVM.OpenJDK.Core.dll",
    "$($ikvm_dir)/bin/IKVM.OpenJDK.Media.dll",
    "$($ikvm_dir)/bin/IKVM.OpenJDK.Security.dll",
    "$($ikvm_dir)/bin/IKVM.OpenJDK.Text.dll",
    "$($ikvm_dir)/bin/IKVM.OpenJDK.Util.dll",
    "$($ikvm_dir)/bin/IKVM.OpenJDK.XML.API.dll",
    "$($ikvm_dir)/bin/IKVM.OpenJDK.SwingAWT.dll",
    "$($ikvm_dir)/bin/IKVM.AWT.WinForms.dll"
)

$ikvm_files | ForEach-Object {
    Copy-Item -Path $_ -Destination $bin_dir
}
