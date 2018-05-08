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