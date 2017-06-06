@Echo Off
::
:: File:        install.bat
::
:: Description: Automatically installs tools for developers, according to the set configuration
:: Author:      Webber
:: License:     MIT
::

::Configuration
Set InstallDir=%SystemRoot:~0,3%dev\
Set ChocolateyToolsLocation=%InstallDir%
Set ChocolateyInstall=%InstallDir%chocolatey\

::SetPermanently
Setx InstallDir %InstallDir% > Nul
Setx ChocolateyInstall %ChocolateyInstall% > Nul
Setx ChocolateyToolsLocation %InstallDir% > Nul

::Refresh PATH Environment Variable
Call Userpath Refresh > Nul

::Create folder for all tools' installations
Mkdir %InstallDir% > Nul 2> Nul

::Chocolatey
:InstallChocolatey
@powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
:PermanentlySetInstallDir
Setx ChocolateyInstall %ChocolateyInstall%
:AddBinaryToUserPath
Call Userpath Add %ChocolateyInstall%bin
:UpdateChocolatey
choco upgrade chocolatey -yes

::PHP
:InstallPhp
choco install php --yes --params "/InstallDir:%InstallDir%php"
:UpdatePhp
choco upgrade php --yes --params "/InstallDir:%InstallDir%php"
:EnableOpenSsl
IniFile.exe %InstallDir%php/php.ini [PHP] extension=./ext/php_openssl.dll
:SetPathIfNoShims
Call Userpath Add %InstallDir%php
:VerifyPhpInstall
php -v

::Composer
:DownloadComposer
php -r "copy('https://getcomposer.org/installer', 'composer/composer-setup.php');"
:CheckComposerIntegrity
Set ComposerHash='669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410'
Set ComposerCondition=hash_file('SHA384', 'composer/composer-setup.php')!==%ComposerHash%
Set ComposerCheck=if(%ComposerCondition%){echo('Installer corrupt');unlink('composer/composer-setup.php');}
php -r "%ComposerCheck%"
:SetupComposer
php composer/composer-setup.php --install-dir=%~dp0/composer --quiet
php -r "unlink('composer/composer-setup.php');"
:MoveComposerToSystem
XCopy /e/i/y/h "%~dp0composer" "%InstallDir%composer" > Nul
:AddPathForComposerFiles
Call Userpath Add %InstallDir%composer
:VerifyComposerInstall
Call composer -V

::Symfony
:InstallSymfony
MkDir symfony & php -r "readfile('https://symfony.com/installer');" > symfony/symfony
:MoveSymfonyToSystem
XCopy /e/i/y/h "%~dp0symfony" "%InstallDir%symfony" > Nul
:AddPathForSymfonyFile
Call Userpath Add %InstallDir%symfony
:VerifySymfonyInstall
Call symfony -V




