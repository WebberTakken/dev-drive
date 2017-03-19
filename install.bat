@Echo Off
:: Download PHP
bitsadmin /transfer "Downloading PHP" /download /priority normal http://windows.php.net/downloads/releases/php-7.1.3-nts-Win32-VC14-x86.zip %~dp0\php.zip
:: Unzip PHP to ./php
cscript //B unzip.vbs php.zip php
:: Use production php.ini
copy /y "%~dp0\php\php.ini-production" "%~dp0\php\php.ini" > NUL
:: Enable SSL Extension
inifile.exe %~dp0/php/php.ini [PHP] extension=./ext/php_openssl.dll
:: Move php to php folder in root of current drive //%CD:~0,3%
xcopy /e/i/y/h "%~dp0php" "%SystemRoot:~0,3%php" > NUL
:: Create Path variable for X:\php
userpath.bat add %SystemRoot:~0,3%php
:: testtt
::php -v
:: Install composer
::%~dp0\php\php -r "copy('https://getcomposer.org/installer', 'composer/composer-setup.php');"
::%~dp0\php\php.exe -r "if (hash_file('SHA384', 'composer/composer-setup.php') !== '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer corrupt'; unlink('composer/composer-setup.php'); }"
::%~dp0\php\php.exe composer/composer-setup.php --install-dir=%~dp0/composer --quiet
::%~dp0\php\php.exe -r "unlink('composer/composer-setup.php');"
:: Install Symfony
::mkdir symfony & php -r "readfile('https://symfony.com/installer');" > symfony/symfony