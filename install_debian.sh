#!/bin/sh
#create dir
mkdir deps
cd deps

CPU=`grep -c processor /proc/cpuinfo`

#remove old packages
sudo apt-get remove gphoto2 libgphoto2-2 libgphoto2-l10n libgphoto2-port0 jhead

#install needed packages
sudo apt-get install build-essential libtool libusb-1.0-0-dev libusb-dev libjpeg-dev libexif-dev libpopt-dev liblockdev1-dev libreadline-dev libcdk5-dev libaa1-dev libgd2-xpm-dev git autoconf

#download sources
#wget "http://sourceforge.net/projects/gphoto/files/libgphoto/2.5.1.1/libgphoto2-2.5.1.1.tar.bz2/download" -O libgphoto2-2.5.1.1.tar.gz
git clone https://github.com/fape/libgphoto2.git
cd libgphoto2
git submodule update --init
cd ..
git clone https://github.com/fape/gphoto2.git
cd gphoto2
git submodule update --init
cd ..
#wget "http://sourceforge.net/projects/gphoto/files/gphoto/2.5.1/gphoto2-2.5.1.tar.gz/download" -O gphoto2-2.5.1.tar.gz
wget "http://www.sentex.net/~mwandel/jhead/jhead-2.97.tar.gz"

#extract
echo *.tar.gz | xargs -n 1 tar -xvf

#install libgphoto2
cd libgphoto2
autoreconf -is
./configure --prefix=/usr
make -j $CPU
sudo make install

#install gphoto2
cd ../gphoto2
autoreconf -is
./configure --with-aalib
make
sudo make install

#install jhead
cd ../jhead-2.97
make
sudo make install

#check
cd ~
gphoto2 --version
jhead -V

