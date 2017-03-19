@Echo Off

::Refresh PATH Environment Variable
Call Userpath Refresh > Nul

::PHP
:DownloadPhp
Call Download http://windows.php.net/downloads/releases/php-7.1.3-nts-Win32-VC14-x86.zip php.zip
:UnzipPhp
CScript Unzip.vbs php.zip php
:UseProductionIni
Copy /y "%~dp0\php\php.ini-production" "%~dp0\php\php.ini" > Nul
:EnablePhpSsl
IniFile.exe %~dp0/php/php.ini [PHP] extension=./ext/php_openssl.dll
:MovePhpToSystem
XCopy /e/i/y/h "%~dp0php" "%SystemRoot:~0,3%php" > Nul
:AddPathForPhpBinary
Call Userpath Add %SystemRoot:~0,3%php
:TestPhpInstall
php -v

::Composer
:InstallComposer
php -r "copy('https://getcomposer.org/installer', 'composer/composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer/composer-setup.php') !== '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer corrupt'; unlink('composer/composer-setup.php'); }"
php composer/composer-setup.php --install-dir=%~dp0/composer --quiet
php -r "unlink('composer/composer-setup.php');"
:MoveComposerToSystem
XCopy /e/i/y/h "%~dp0composer" "%SystemRoot:~0,3%composer" > Nul
:AddPathForComposerFiles
Call Userpath Add %SystemRoot:~0,3%composer

::Symfony
:InstallSymfony
MkDir symfony & php -r "readfile('https://symfony.com/installer');" > symfony/symfony
:MoveSymfonyToSystem
XCopy /e/i/y/h "%~dp0symfony" "%SystemRoot:~0,3%symfony" > Nul
:AddPathForSymfonyFile
Call Userpath Add %SystemRoot:~0,3%symfony