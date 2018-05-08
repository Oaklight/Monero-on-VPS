# select mode for miner, proxy, or both
read -p "Modes for installation:
 1) miner-only
 2) proxy-only
 3) miner-and-proxy
Your choice: " mode

proxyOn=0
minerOn=0

case $mode in
1) echo "Installation for miner only!"
    minerOn=1
    ;;
2) echo "Installation for proxy only!"
    proxyOn=1
    ;;
3) echo "Installation for both miner and proxy!"
    proxyOn=1
    minerOn=1
    ;;
*) echo "Invalid input, pls check again"
    exit 0
    ;;
esac

# install centos devtoolset-7 and set active
read -p "Should devtoolset-7 be added to .bash_profile?
1) Yes, for-ever
0) No, for now
Your choice: " always
if [[ $always ]]; then
    echo "Enable devtoolset-7 forever"
    echo "scl enable devtoolset-7 bash" > ~/.bash_profile
else
    echo "Enable devtoolset-7 for now"
    sed -i 's/scl enable devtoolset-7 bash//1' ~/.bash_profile
fi

# check platform version: i686 or x86_64
OS=$(uname -m)
echo ""
echo "Current system is $OS"
echo ""

yum update -y
yum install -y epel-release
yum install -y git make cmake gcc gcc-c++ libstdc++-static libmicrohttpd-devel libuv-static
# install yum-utils for yum-config-manager
yum install -y yum-utils

if [[ $OS = "i686" ]]; then # on 32-bit platform
    # add 3rd-party repo for i686 build scl
    yum-config-manager --add-repo https://copr.fedorainfracloud.org/coprs/mlampe/devtoolset-7/repo/epel-6/mlampe-devtoolset-7-epel-6.repo
    yum install -y devtoolset-7-toolchain
elif [[ $OS = "x86_64" ]]; then # on 64-bit platform
    yum install -y centos-release-scl
    yum-config-manager --enable rhel-server-rhscl-7-rpms
    yum install -y devtoolset-7
else
    echo "incoming feature"
    exit 1
fi
scl enable devtoolset-7 bash

# download and build dependencies
mkdir -p deps && cd $_ # @ Monero-on-VPS/deps

# dependency existance check first
# incoming features

# ldconfig -p | grep libuv
wget https://github.com/libuv/libuv/archive/v1.x.zip
unzip v1.x.zip; rm $_ -f
cd libuv-1.x
# build and install libuv
sh autogen.sh
./configure
make
# make check
make install
cd .. # @ Monero-on-VPS/deps
rm libuv-1.x -rf

if [[ $proxyOn ]]; then
    # install for proxy: xmrig-proxy
    yum install -y libuuid libuuid-devel
    wget https://github.com/xmrig/xmrig-proxy/archive/master.zip
    unzip master.zip
    rm $_ -f
    cd xmrig-proxy-master
    mkdir -p build && cd $_ # @ Monero-on-VPS/deps/xmrig-proxy-master/build
    cmake -DCMAKE_BUILD_TYPE=Release ../
    make
    mkdir ../../../xmrig-proxy
    mv xmrig-proxy ../../../xmrig-proxy/
    # create config file
    touch ../../../xmrig-proxy/config.json
    cd ../../..
fi

if [[ $minerOn ]]; then
    # install for miner: xmrig
    wget https://github.com/xmrig/xmrig/archive/master.zip
    unzip master.zip
    rm $_ -f
    cd xmrig-master
    # reset the donate-level to 0
    sed -i 's/kDonateLevel = 5/kDonateLevel = 0/1' src/donate.h
    mkdir -p build && cd $_
    cmake -DCMAKE_BUILD_TYPE=Release -DWITH_HTTPD=OFF ../
    make
    mkdir ../../../xmrig
    mv xmrig ../../../xmrig/
    # create config file
    touch ../../../xmrig/config.json
    cd ../../..
fi

rm deps/ -rf

