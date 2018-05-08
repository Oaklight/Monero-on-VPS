# select mode for miner, proxy, or both
read -p "Modes for installation:
 1) miner-only
 2) proxy-only
 3) miner-and-proxy
Your choice: " mode
case $mode in
1) echo "Installation for miner only!"
    minerOn=1
    proxyOn=0
    ;;
2) echo "Installation for proxy only!"
    minerOn=0
    proxyOn=1
    ;;
3) echo "Installation for both miner and proxy!"
    minerOn=1
    proxyOn=1
    ;;
*) echo "Invalid input, pls check again"
    exit 0
    ;;
esac
echo ""

# install centos devtoolset-7 and set active
read -p "Should devtoolset-7 be added to .bash_profile?
0) No, for now
1) Yes, for-ever
Your choice: " always
case $always in
0) echo "Enable devtoolset-7 for now"
    sed -i 's/scl enable devtoolset-7 bash//1' ~/.bash_profile
    ;;
1) echo "Enable devtoolset-7 forever"
    echo "scl enable devtoolset-7 bash" > ~/.bash_profile
    ;;
*) echo "Invalid input, pls check again"
    exit 0
    ;;
esac
echo ""

read -p "Do you need to access the miner or proxy to view the status?
0) No, I don't
1) Yes, please
Your choice: " server
if [[ $server = "1" ]]; then
    yum install -y -q libmicrohttpd-devel
fi
echo ""

# yum update -y

# check platform version: i686 or x86_64
OS=$(uname -m)
echo "Current system is $OS"
echo ""
# install yum-utils for yum-config-manager
yum install -y -q yum-utils unzip
if [[ $OS = "i686" ]]; then # on 32-bit platform
    # yum update -y
    yum install -y -q epel-release
    yum install -y -q make gcc gcc-c++ libstdc++-static
    # add 3rd-party repo for i686 build scl
    yum-config-manager --add-repo https://copr.fedorainfracloud.org/coprs/mlampe/devtoolset-7/repo/epel-6/mlampe-devtoolset-7-epel-6.repo
    yum install -y -q  devtoolset-7-toolchain cmake
elif [[ $OS = "x86_64" ]]; then # on 64-bit platform
    yum install -y -q centos-release-scl
    yum-config-manager --enable rhel-server-rhscl-7-rpms
    yum install -y -q devtoolset-7 cmake 
else
    echo "incoming feature"
    exit 1
fi
# # this will fork an child bash and suspend the current execution
# scl enable devtoolset-7 bash

mkdir -p deps && cd $_

chmod 100 ../install-libuv.sh; mv $_ ./
chmod 100 ../install-xmrig.sh; mv $_ ./
chmod 100 ../install-proxy.sh; mv $_ ./

# dependency existance check first
# incoming features

scl enable devtoolset-7 "./install-libuv.sh"

if [[ $minerOn = "1" ]]; then
    scl enable devtoolset-7 "./install-xmrig.sh"
fi

if [[ $proxyOn = "1" ]]; then
    scl enable devtoolset-7 "./install-proxy.sh"
fi

cd ../
nano ./xmrig/config.json
nano ./xmrig-proxy/config.json
# rm deps/ -rf

