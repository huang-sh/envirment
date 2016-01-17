function setDebug() {
    echo -n "开启debug? [yes/no]:";
    while [ true ]
    do
        read answer
        if [ $answer = "no" ];then
            debug="--disable-debug"
            break
        elif [ $answer = "yes" ];then
            debug="--enable-debug"
            break
        else
            echo -n "输入:[yes/no]:"
        fi
    done
}
setDebug
dir=`pwd`
phpPath=$(cd "$dir/../php"; pwd)
depend=$(cd "$dir/../source/depend"; pwd)
cd $dir/../source/php

# 删除Makefile
if [ -f "Makefile" ]; then
    sudo make clean
    rm Makefile
fi

openssl=$(cd "$depend/nginx/openssl"; pwd)

# 编译所有的扩展
./configure --prefix=$phpPath \
    --with-config-file-path=$phpPath/etc \
    --with-config-file-scan-dir=$phpPath/ext \
    --enable-bcmath \
    --enable-fpm \
    --enable-gd-native-ttf \
    --enable-mbstring \
    --enable-shmop \
    --enable-soap \
    --enable-sockets \
    --enable-sysvsem \
    --enable-pcntl \
    --enable-zip \
    --enable-gd-jis-conv \
    --enable-ftp \
    --enable-calendar \
    --enable-exif \
    --enable-fd-setsize=4096 \
    --with-gd \
    --with-openssl \
    --with-zlib \
    --with-pear \
    --with-xmlrpc \
    --with-curl \
    --with-mcrypt \
    --with-t1lib \
    --with-freetype-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-libxml-dir \
    --with-mysql \
    --with-pdo-mysql \
    --with-xpm-dir \
    --with-gettext \
    --with-freetype-dir \
    --with-iconv-dir \
    --with-fpm-user=www \
    --with-fpm-group=www \
    $debug

if [ -f "Makefile" ]; then
    sudo make && make install
fi
cd $dir
