# install yum-utils for yum-config-manager
yum install yum-utils

# install centos devtoolset-7 and set active
yum install  epel-release
yum install git make cmake gcc gcc-c++ libstdc++-static libmicrohttpd-devel libuv-static

# on 32-bit platform

# add 3rd-party repo for i686 build scl
yum-config-manager --add-repo https://copr.fedorainfracloud.org/coprs/mlampe/devtoolset-7/repo/epel-6/mlampe-devtoolset-7-epel-6.repo
scl enable devtoolset-7

# on 64-bit platform
#

# install libuv dependency
git clone https://github.com/libuv/libuv.git || true

cd libuv
sh autogen.sh
./configure
make
make check
make install

# install xmrig
git clone https://github.com/xmrig/xmrig.git || true

cd xmrig
mkdir -p build
cd build
# need to reset the contribution to 0
cmake .. -DCMAKE_BUILD_TYPE=Release
make
