$chefVersion = '12.18.31'
$pkgRelease = '-1'
$windowsVerson = '2012r2'
$MsiUrl = "https://packages.chef.io/files/stable/chef/$chefVersion/windows/$windowsVerson/chef-client-$chefVersion$pkgRelease-x86.msi"
$MsiUrlx64 = "https://packages.chef.io/files/stable/chef/$chefVersion/windows/$windowsVerson/chef-client-$chefVersion$pkgRelease-x64.msi"
$ChefInstallerPath = 'c:\vagrant\resources\installers'
$ChefLocalInstallerFileName = 'chef-client.msi'
if ([System.IntPtr]::Size -eq 8) {
  Write-Host "Going Chef 64-bit."
  $MsiUrl = $MsiUrlx64
  $ChefLocalInstallerFileName = 'chef-client-x64.msi'
}
$ChefInstaller = Join-Path $ChefInstallerPath $ChefLocalInstallerFileName

$ChefInstalled = $false
try {
  $ErrorActionPreference = "Stop";
  Get-Command chef-client | Out-Null
  $ChefInstalled = $true
  $chefVersion=&chef-client "--version"
  Write-Host "Chef $chefVersion is installed. This process does not ensure the exact version or at least version specified, but only that Chef is installed. Exiting..."
  Exit 0
} catch {
  Write-Host "Chef is not installed, continuing..."
}

if (!($ChefInstalled)) {
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  if (! ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host -ForegroundColor Red "You must run this script as an administrator."
    Exit 1
  }

  if (!(Test-Path $ChefInstallerPath)) {
    Write-Host "Creating folder '$ChefInstallerPath'"
    $null = New-Item -Path "$ChefInstallerPath" -ItemType Directory
  }

  if (!(Test-Path $ChefInstaller)) {
    Write-Host "Downloading '$MsiUrl' to '$ChefInstaller'"
    (New-Object Net.WebClient).DownloadFile("$MsiUrl","$ChefInstaller")
  }

  # Install it - msiexec will download from the url
  $install_args = @("/qn", "/norestart","/i", "$ChefInstaller")
  Write-Host "Installing Chef. Running msiexec.exe $install_args"
  $process = Start-Process -FilePath msiexec.exe -ArgumentList $install_args -Wait -PassThru
  if ($process.ExitCode -ne 0) {
    Write-Host "Installer failed."
    Exit 1
  }

  Write-Host "Chef successfully installed."
}
