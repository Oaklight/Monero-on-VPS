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

# yum update -y
yum install -y epel-release
yum install -y git automake make cmake gcc gcc-c++ libstdc++-static libmicrohttpd-devel libuv-static
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
# scl enable devtoolset-7 bash

mkdir -p deps && cd $_

chmod 100 ../install-libuv.sh; mv $_ ./
chmod 100 ../install-xmrig.sh; mv $_ ./
chmod 100 ../install-proxy.sh; mv $_ ./

# dependency existance check first
# incoming features

scl enable devtoolset-7 "./install-libuv.sh"

if [[ $minerOn ]]; then
    scl enable devtoolset-7 "./install-xmrig.sh"
fi

if [[ $proxyOn ]]; then
    scl enable devtoolset-7 "./install-proxy.sh"
fi

cd ../
# rm deps/ -rf

