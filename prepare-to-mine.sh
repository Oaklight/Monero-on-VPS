# install yum-utils for yum-config-manager
yum install yum-utils
# install centos devtoolset-7 and set active
yum install  epel-release
yum install git make cmake gcc gcc-c++ libstdc++-static libmicrohttpd-devel libuv-static
# on 32-bit platform
# add 3rd-party repo for i686 build scl
yum-config-manager --add-repo https://copr.fedorainfracloud.org/coprs/mlampe/devtoolset-7/repo/epel-6/mlampe-devtoolset-7-epel-6.repo
yum install devtoolset-7-toolchain
scl enable devtoolset-7 bash

# on 64-bit platform
#

mkdir -p dependencies && cd $_

# install libuv dependency
# dependency existance check first
# ldconfig -p | grep libuv
wget https://github.com/libuv/libuv/archive/v1.x.zip
unzip v1.x.zip
rm v1.x.zip
cd libuv-1.x
# build and install libuv
sh autogen.sh
./configure
make
# make check
make install
cd ..
rm libuv-1.x -rf

# install xmrig
wget https://github.com/xmrig/xmrig/archive/master.zip
unzip master.zip
rm master.zip
cd xmrig-master
# reset the donate-level to 0
sed -i 's/kDonateLevel = 5/kDonateLevel = 0/1' src/donate.h
# build xmrig
mkdir -p build && cd $_
cmake -DCMAKE_BUILD_TYPE=Release -DWITH_HTTPD=OFF ../
make
# copy the build to outer folder
mv xmrig ../../../xmrig
cd ../../..

rm -rf dependencies/
# create config file
touch config.json