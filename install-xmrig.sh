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
# echo "# config file for xmrig" > $_
cd ../../