apt-get update > /dev/null
apt-get install -y apt-utils > /dev/null
apt-get install -y git wget cmake build-essential zsh device-tree-compiler vim-nox \
                       rlwrap libncurses5 libtinfo5 libxrender1 libxtst6 u-boot-tools \ 
                       libglib2.0-0 libsm6 libxi6 libxrender1 libxrandr2 libfreetype6 \
                       libfontconfig iproute2 x11-utils xvfb dbus dbus-x11 libgtk-3-dev > /dev/null

wget http://deb.debian.org/debian/pool/main/o/openssl1.0/libssl1.0.2_1.0.2u-1~deb9u1_amd64.deb
dpkg -i libssl1.0.2_1.0.2u-1~deb9u1_amd64.deb
rm libssl1.0.2_1.0.2u-1~deb9u1_amd64.deb
wget http://deb.debian.org/debian/pool/main/o/openssl1.0/libssl1.0-dev_1.0.2u-1~deb9u1_amd64.deb
dpkg -i libssl1.0-dev_1.0.2u-1~deb9u1_amd64.deb
rm libssl1.0-dev_1.0.2u-1~deb9u1_amd64.deb

