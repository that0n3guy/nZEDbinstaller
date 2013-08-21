#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
        echo "You must be root to do this DOH...." 1>&2
        exit 100
fi

clear
echo '
                                                ______________________________________________
                                                |                                            |
                                                |              .,-:;//;:=,                   |
                                                |            . :H@@@MM@M#H/.,+%;,            |
                                                |         ,/X+ +M@@M@MM%=,-%HMMM@X/,         |
                                                |       -+@MM; $M@@MH+-,;XMMMM@MMMM@+-       |
                                                |      ;@M@@M- XM@X;. -+XXXXXHHH@M@M#@/.     |
                                                |    ,%MM@@MH ,@%=            .---=-=:=,.    |
                                                |    =@#@@@MX .,              -%HX$$%%%+;    |
                                                |   =-./@M@M$                  .;@MMMM@MM:   |
                                                |   X@/ -$MM/                    .+MM@@@M$   |
                                                |  ,@M@H: :@:                    . =X#@@@@-  |
                                                |  ,@@@MMX, .                    /H- ;@M@M=  |
                                                |  .H@@@@M@+,                    %MM+..%#$.  |
                                                |   /MMMM@MMH/.                  XM@MH; =;   |
                                                |    /%+%$XHH@$=              , .H@@@@MX,    |
                                                |     .=--------.           -%H.,@@@@@MX,    |
                                                |     .%MM@@@HHHXX$$$%+- .:$MMX =M@@MM%.     |
                                                |       =XMMM@MM@MM#H;,-+HMM@M+ /MMMX=       |
                                                |         =%@M@M#@$-.=$@MM@@@M; %M%=         |
                                                |           ,:+$+-,/H#MMMMMMM@= =,           |
                                                |                 =++%%%%+/:-.               |
                                                |____________________________________________|'
echo
echo -e '\033[1;33m                                                         nZEDb Autoinstaller\033[0m'
sleep 5



clear
echo -e "\033[1;33mThis installs nZEDb, Mysql SQL Server and everything that is needed to your Ubuntu install.\033[0m"
echo
echo "Setup will continue in a few seconds."
echo
echo "This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License"
echo "version 2, as published by the Free Software Foundation."
echo
echo "This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied"
echo "warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
echo "See the GNU General Public License for more details."
echo 
echo "This has been modified to work specifically with Ubuntu 12.04."

echo
echo

for i in {1..5}; do echo -n " ." && sleep 1; done

clear
echo "DISCLAIMER"
echo " # This script is made available to you without any express, implied or "
echo " # statutory warranty, not even the implied warranty of "
echo " # merchantability or fitness for a particular purpose, or the "
echo " # warranty of title. The entire risk of the use or the results from the use of this script remains with you."
echo
echo -e "\033[1;33m # This script was written by Zombu2. Questions? visit me on IRC @ irc.synIRC.net #nZEDb or visit our Forum at http://nzedb.com\033[0m"
echo
echo "---------------------------------------------------------------------------------------------------------------"
echo "Do you Agree?"
echo "y=YES n=NO"

read CHOICE
if [[ $CHOICE != "y" ]]; then
    exit
fi


clear

# Lets see if apparmor is installed...if yes remove it
echo "Finding out if Apparmor is installed ...If yes remove it"
for i in {1...5}; do echo -n " ." && sleep 1; done
if dpkg --list apparmor | egrep -q ^ii;
then
clear
echo "Apparmor found ....Removing it now"
for i in {1...5}; do echo -n " ." && sleep 1; done
clear
/etc/init.d/apparmor stop
/etc/init.d/apparmor teardown
update-rc.d -f apparmor remove
apt-get -qq remove --purge apparmor
rm -rf /etc/apparmor.d
rm -rf /atc/apparmor
sleep 2
clear
echo "Apparmor successfully removed"
for i in {1...5}; do echi -n " ." && sleep 1; done
else
echo "Apparmor not found"
sleep 3
fi



clear

#checking if on linux mint 14 ... if yes fixing some things up to prevent locale errors

OS=$(awk '/DISTRIB_ID=/' /etc/*-release | sed 's/DISTRIB_ID=//' | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VERSION=$(awk '/DISTRIB_RELEASE=/' /etc/*-release | sed 's/DISTRIB_RELEASE=//' | sed 's/[.]0/./')

if [ -z "$OS" ]; then
    OS=$(awk '{print $1}' /etc/*-release | tr '[:upper:]' '[:lower:]')
fi

if [ -z "$VERSION" ]; then
    VERSION=$(awk '{print $3}' /etc/*-release)
fi

echo $OS
echo $ARCH
echo $VERSION
if [ "$OS" = "linuxmint" -a "$VERSION" = "14" ];
then
clear
echo "Fixing some things"
for i in {1..5}; do echo -n " ." && sleep 1; done
locale-gen --purge --no-archive
else
clear
echo "Nothing to do for me here"
sleep 2
fi



clear
echo "You can install the ffmpeg package or compile from source. To install the ffmpeg package type \"y\", if your using ubuntu, you should probably hit \"n\"."
echo "y=YES n=NO"
read COMPILE

clear
echo "Install extra apps that are not necessarily needed for nZEDb operation.."
echo "y=YES n=NO"
read EXTRAS

clear
echo "Do you want to install PhpMyadmin?.."
echo "y=YES n=NO"
read PHPMY


#Installing Prerequirements
echo "Installing Prerequirements......"



apt-get --quiet --quiet update
sudo apt-get install -qq python-software-properties
# needed for adding php 5.4 as of 8/21/2013
add-apt-repository ppa:ondrej/php5-oldstable
apt-get --quiet --quiet update

apt-get install -qq git
apt-get install -qq apache2
apt-get install -qq mysql-server
apt-get install -qq mysql-client
apt-get install -qq libmysqlclient-dev
apt-get install -qq php5
apt-get install -qq php5-fpm
apt-get install -qq php5-dev
apt-get install -qq php-pear
apt-get install -qq php5-gd
apt-get install -qq php5-mysqlnd
apt-get install -qq php5-curl
apt-get install -qq openssh-server
apt-get install -qq software-properties-common
apt-get install -qq ca-certificates
apt-get install -qq ssl-cert
apt-get install -qq subversion
apt-get install -qq php5-svn
apt-get install -qq php-apc
apt-get install -qq python-mysqldb
apt-get install -qq tmux
apt-get install -qq python-setuptools
apt-get install -qq python-mysqldb
apt-get install -qq python-pip

mkdir -p /var/www/nZEDb
chmod 777 /var/www/nZEDb

git config--global core.filemode false
git clone https://github.com/nZEDb/nZEDb.git /var/www/nZEDb

chmod -R 775 /var/www/nZEDb/www/lib/smarty/templates_c
chmod -R 775 /var/www/nZEDb/www/covers
chmod -R 775 /var/www/nZEDb/nzbfiles
mkdir /var/www/nZEDb/nzbfiles/tmpunrar -p
chmod -R 775 /var/www/nZEDb/nzbfiles/tmpunrar
chmod 775 /var/www/nZEDb/www
chmod 775 /var/www/nZEDb/www/install
chown -R www-data:www-data /var/www/

clear
echo "Adding a line to your fstab."
echo "This will give you a ramdisk of 128M for tmpunrar located here: /var/www/nZEDb/nzbfiles/tmpunrar"
echo "...see the faq #7 here: http://nzedb.com/index.php?topic=41.0"
echo "" >> /etc/fstab
echo "#nZEDb installer added this" >> /etc/fstab
echo "none /var/www/nZEDb/nzbfiles/tmpunrar   tmpfs  nodev,nodiratime,noexec,nosuid,size=128M 0 0" >> /etc/fstab

sleep 5
clear
echo "This installer sets the memory limit to 512"
echo "On some low memory machines this can cause lockups and dataloss"
echo "If you have a low memory machine please edit the following files to your likeing"

echo "/etc/php5/fpm/php.ini <<<<<--- edit memory_limit"
echo "/etc/php5/cli/php.ini <<<<<--- edit memory_limit"
echo "/etc/php5/apache2/php.ini <<<<<--- edit memory_limit"

echo "Safe Limits for low memory machines is 512Mb"

echo "Do you Understand?"
echo "y=YES n=NO"

read CHOICE1
if [[ $CHOICE1 != "y" ]]; then
    exit
fi


clear

sed -i -e 's/max_execution_time.*$/max_execution_time = 120/' /etc/php5/fpm/php.ini
sed -i -e 's/max_execution_time.*$/max_execution_time = 120/' /etc/php5/cli/php.ini
sed -i -e 's/max_execution_time.*$/max_execution_time = 120/' /etc/php5/apache2/php.ini
sed -i -e 's/memory_limit.*$/memory_limit = 512M/' /etc/php5/fpm/php.ini
sed -i -e 's/memory_limit.*$/memory_limit = 512M/' /etc/php5/cli/php.ini
sed -i -e 's/memory_limit.*$/memory_limit = 512M/' /etc/php5/apache2/php.ini
sed -i -e 's/[;?]date.timezone.*$/date.timezone = America\/Chicago/' /etc/php5/fpm/php.ini
sed -i -e 's/[;?]date.timezone.*$/date.timezone = America\/Chicago/' /etc/php5/cli/php.ini
sed -i -e 's/[;?]date.timezone.*$/date.timezone = America\/Chicago/' /etc/php5/apache2/php.ini

#touch /etc/apache2/sites-available/nZEDb

if [ ! -f /etc/apache2/sites-available/nZEDb ]; then
cat << EOF >> /etc/apache2/sites-available/nZEDb
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName localhost

    # These paths should be fine
    DocumentRoot /var/www/nZEDb/www
    ErrorLog /var/log/apache2/error.log
    LogLevel warn
</VirtualHost>
EOF
fi




a2dissite default
a2ensite nZEDb
a2enmod rewrite


service php5-fpm stop
service php5-fpm start
service apache2 restart

add-apt-repository -y ppa:jon-severinsson/ffmpeg
add-apt-repository -y ppa:shiki/mediainfo
echo "Prerequirements installed...."
sleep 5
clear

echo "Installing ffmpeg x264 mediainfo unrar lame..."

if [[ $COMPILE != "y" ]];
then
    apt-get --quiet --quiet update
    apt-get install -qq build-essential checkinstall
    apt-get remove -q ffmpeg x264 libav-tools libvpx-dev libx264-dev

    apt-get install -qq autoconf libfaac-dev libgpac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev librtmp-dev libtheora-dev libtool libvorbis-dev pkg-config texi2html zlib1g-dev

    cd /tmp
    wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
    tar xzvf yasm-1.2.0.tar.gz
    cd yasm-1.2.0
    ./configure
    make && checkinstall --pkgname=yasm --pkgversion="1.2.0" --backup=no --deldoc=yes --default

    git clone --depth 1 git://git.videolan.org/x264 /tmp/x264
    cd /tmp/x264
    ./configure --enable-static
    make && checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes --fstrans=no --default

    git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git /tmp/fdk-aac
    cd /tmp/fdk-aac
    autoreconf -fiv
    ./configure --disable-shared
    make && checkinstall --pkgname=fdk-aac --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default

    git clone --depth 1 http://git.chromium.org/webm/libvpx.git /tmp/libvpx
    cd /tmp/libvpx
    ./configure
    make && checkinstall --pkgname=libvpx --pkgversion="1:$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default

    git clone --depth 1 git://source.ffmpeg.org/ffmpeg /tmp/ffmpeg
    cd /tmp/ffmpeg
    ./configure --enable-gpl --enable-libfaac --enable-libfdk-aac --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-librtmp --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-nonfree --enable-version3
    make && checkinstall --pkgname=ffmpeg --pkgversion="7:$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default

    apt-get install -qq libavcodec-extra-53 libav-tools
    hash x264 ffmpeg ffprobe

    cd /tmp/ffmpeg
    make tools/qt-faststart
    sudo checkinstall --pkgname=qt-faststart --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default install -Dm755 tools/qt-faststart /usr/local/bin/qt-faststart

    cd /tmp/x264
    make distclean
    ./configure --enable-static
    make && checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes --fstrans=no --default

    apt-get install -qq unrar lame mediainfo

    clear
    echo "ffmpeg x264 mediainfo unrar lame is now installed..."
    sleep 5
else
    apt-get install -qq ffmpeg libavcodec-extra-53 libavutil-extra-51 unrar x264 libav-tools libvpx-dev libx264-dev
    apt-get install -qq lame mediainfo
fi

if [[ $EXTRAS == "y" ]];
then
    apt-get install -qq nmon mytop iftop bwm-ng vnstat atop iotop ifstat htop pastebinit pigz iperf geany geany-plugins-common geany-plugins geany-plugin-spellcheck ttf-mscorefonts-installer diffuse meld tinyca perl-doc
    mv /bin/gzip /bin/gzip.old
    ln -s /usr/bin/pigz /bin/gzip
fi

if [[ $PHPMY == "y" ]];
then
        apt-get install -qq phpmyadmin
fi




sh -c 'echo "ServerName localhost" >> /etc/apache2/conf.d/name' && sudo service apache2 restart
cp /usr/share/doc/php-apc/apc.php /var/www/nZEDb/www/admin/apc.php

service php5-fpm stop
service php5-fpm start
service apache2 restart
service mysql restart
clear
echo -e "\033[1;33m-----------------------------------------------"
echo -e "\033[1;33mInstall Complete...."
echo "Go to http://localhost/install to finish nZEDb install."
echo "For questions and problems log on to #nZEDb on Synirc"
echo -e "\n\n"
exit 100

