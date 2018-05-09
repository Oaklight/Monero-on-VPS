# install for proxy: xmrig-proxy
yum install -y libuuid libuuid-devel
wget https://github.com/xmrig/xmrig-proxy/archive/master.zip
unzip master.zip
rm $_ -f
cd xmrig-proxy-master
# reset the donate-level to 0
sed -i 's/kDefaultDonateLevel = 2/kDefaultDonateLevel = 0/1' src/donate.h
sed -i 's/kMinimumDonateLevel = 0/kMinimumDonateLevel = 0/1' src/donate.h
sed -i 's/kFreeThreshold = 256/kFreeThreshold = 1000000/1' src/donate.h

mkdir -p build && cd $_ # @ Monero-on-VPS/deps/xmrig-proxy-master/build
cmake -DCMAKE_BUILD_TYPE=Release ../
make
mkdir ../../../xmrig-proxy
mv xmrig-proxy ../../../xmrig-proxy/
# create config file
touch ../../../xmrig-proxy/config.json
# echo "# config file for xmrig-proxy" > $_
cd ../../