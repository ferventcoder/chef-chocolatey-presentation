# Chef Workshop on Chocolatey

## Agenda

* Welcome
* Introductions
* Introduction to Chocolatey
* Introduction to Chocolatey for Business
* Roadmap
* Exercises 0 - 6 (Setup and Package Creation)
* Lunch 11AM-12PM PST (13:00 CST / 14:00 EST)
* Chocolatey Ecosystem
* Rest of Exercises

## Exercises

### Exercise 0: Setup

It's preferred that you perform all of this exercise from a Vagrant image, but you can follow along with a physical Windows box.

1. Ensure you have a recent version of [Vagrant](https://downloads.vagrantup.com). It is suggested you have at least 1.8.x for linked clones which makes Windows VMs come up lightning quick. Windows machine - `choco install vagrant -y` (then `refreshenv`).
1. Pre-download the vagrant box we will be using - `vagrant init ferventcoder/win2012r2-x64-nocm` (this is a 4GB box, about 8GB unpacked).
1. While that is downloading, ensure you have VirtualBox 5 or 5.1 installed. Windows install is `choco install virtualbox -y`
1. All the rest of these commands will be done inside the Vagrant box (or box you are using for this).
1. Place the license you received by email in demo/resources/licenses. Or copy the `chocolatey.license.xml` to `C:\ProgramData\Chocolatey\license` (you will need to create the license folder).
1. Run `vagrant up` (or `vagrant provision` if already running).
1. Install the licensed edition of Chocolatey - C4B (Chocolatey for Business):
   * Type `choco install chocolatey.extension -y`
   * If you get curious, check out `choco source list`.
1. Run the following commands:

   ~~~sh
   choco config set virusScannerType VirusTotal
   choco feature enable -n virusCheck
   choco feature enable -n allowPreviewFeatures
   ~~~

1. Install the latest GUI - `choco install chocolateygui --source https://www.myget.org/F/chocolateygui/ --pre -y` - this may error.
1. Install Launchy - `choco install launchy -y`
1. Upgrade Notepad++ - `choco upgrade notepadplusplus -y`
1. Install baretail - `choco install baretail -y`
1. Add the PowerShell profile - type `Set-Content -Path $profile -Encoding UTF8 -Value ""`
1. Open the profile file and add the following content:

    ~~~powershell
    $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    if (Test-Path($ChocolateyProfile)) {
      Import-Module "$ChocolateyProfile"
    }
    ~~~
 1. Create a folder for packages - `mkdir packages`
 1. Navigate to the packages folder. All commands from here will be in that packages folder.

### Exercise 1: Install Visual Studio Code

1. Call `choco install visualstudiocode -y`
1. Note the message "Environment Vars have changed".
1. Type `code`. Notice that it errors.
1. Type `refreshenv`.
1. Type `code`. Note that it opens Visual Studio Code.

### Exercise 2: Create a package the old fashioned way

1. Download Google Chrome from https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi and https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise.msi.
1. From a command line, call `choco new googlechrome`.
1. Work through the packaging setup to get a functioning unattended deployment.
1. Run `choco pack`
1. Install the package using Chocolatey - `choco install googlechrome -y -s .`

### Exercise 3: Create a package with Package Builder UI
Let's start by packaging up and installing ChefDK
 1. Run PowerShell as an administrator
 1. Type `packagebuilder` and hit enter.
 1. Go to https://downloads.chef.io/chefdk/#windows (SHA256: 6a4993f1ff36200ffa2922d35a939cc650759b28774f9f745e2d32739f29d298 / URL: https://packages.chef.io/files/stable/chefdk/1.2.22/windows/2012/chefdk-1.2.22-1-x86.msi)
 1. In the interface that comes up, let's put in the ChefDK up
 1. Also pass the SHA for verifying the file is what we hope.
 1. Click the box next to "Don't embed (don't include software binaries in package)?"
 1. Click on Nuspec Information tab.
 1. In id, insert "chefdk".
 1. Click Generate
 1. Note that it creates a full package.
 1. Open up the packaging files in code.
 1. Open the chefdk.nuspec file.
    * Note how auto-detection filled out some of the fields here
    * Optionally we can remove some of the commented sections to tidy this file up and provide more information.
 1. In the chocolateyInstall.ps1, note that it captured all MSI properties and prepared a fully ready to go installation.
    * Also note how it created nice packaging.
    * Optionally we can remove some of the comments and areas we don't need to tidy this up.
 1. Right click on chefdk.nuspec and select "Compile Chocolatey Package..." / type `choco pack` from that directory.
 1. Copy the resulting file up a directory
 1. Call `choco install chefdk -s . -y` (this tells Chocolatey to install from the local source location ".", which is current directory in both PowerShell and Cmd.exe)

### Exercise 4: Create a package with Package Builder (Right Click)

1. Download 1Password from this link - https://d13itkw33a7sus.cloudfront.net/dist/1P/win4/1Password-4.6.0.598.exe (ensure you unblock the file).
1. Right click on the file and choose "Create Chocolatey Package w/out GUI" - **NOTE**: This may error if UAC is on - if so, choose `Create Chocolatey Package...` instead and just click Generate when it comes up.
1. Inspect the output.
1. Let's install this package - `choco install 1password -s . -y --dir c:\programs\1password` (from the working directory where the nupkg is located).
1. Download Charles Proxy (both 32 and 64 bit) - https://www.charlesproxy.com/download/
1. Right click on the 32 bit download and choose "Create Chocolatey Package..."
1. Add the 64bit one into the field.
1. Click generate.
1. Inspect the output.
1. Install this package with `choco install charles -s . -y` (from the working directory where the nupkg is located)
1. Download 7zip - http://www.7-zip.org/download.html (just the 64bit version)
1. Right click and choose "Create Chocolatey Package..."
1. Click Generate.
1. Inspect the output. Note that it doesn't necessarily figure out the silent arguments.
1. Add the proper silent arguments in the install script.
1. Right click on the 7zip nuspec and select "Compile Chocolatey Package..."


### Exercise 5: Create a package with Package Builder CLI

1. Let's create that GoogleChrome package is again.
1. Run `choco new --file googlechromestandaloneenterprise.msi --file64 googlechromestandaloneenterprise64.msi --build-package --outputdirectory $pwd`
1. Inspect the output.


### Exercise 6: Create all the packages

1. Type `packagebuilder`.
1. Change output directory to add "programs" to the path (just to keep things separate). `C:\packages\programs` if you are in the packages folder.
1. Click on the Programs and Features tab.
1. Click `Generate` in that tab.
1. Watch the output.

 OR

1. `choco new --from-programs-and-features --build-package --outputdirectory programs`
1. Watch the output.


*NOTE*: Other exercises left out for now so you don't work ahead too far.
