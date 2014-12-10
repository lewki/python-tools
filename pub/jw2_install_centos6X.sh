#!/bin/sh
#
# install jwoll2 game platform.
# v 0.0.1

USER='jwoll2'
IP='192.168.175.150'
PASSWD='123456'
DBNAME='IDN_JW2_Test_Manager'

SRC_PATH='/usr/local/src'
source /etc/rc.d/init.d/functions

##########################################################
# Intall Beginning 
yum repolist &> /dev/null
yum install wget svn -y &> /dev/null


cd $SRC_PATH 

wget http://soft.ops.morefuntek.com/%e7%b3%bb%e7%bb%9f%e5%88%9d%e5%a7%8b%e5%8c%96%e5%8c%85/init_server_22.tar.gz  &> /dev/null
action 'Download init_server_22 package' [ $? -eq 0 ]

wget -c http://soft.ops.morefuntek.com/gamepkg/jw2_centos6_soft.tar.gz  &> /dev/null
action 'Download jw2_centos6_soft package' [ $? -eq 0 ]

# Initial system 
tar xf init_server_22.tar.gz
cd init_server
if [ ! -x init_server.sh ]
then 
     chmod +x init_server.sh
fi
./init_server.sh  &> /dev/null
action 'Initial system already' [ $? -eq 0 ]
cd ..

# Install jwoll2 planform
tar xf jw2_centos6_soft.tar.gz 
cd jw2_centos6_soft
if [ ! -x install.sh ]
then
    chmod +x install.sh
fi
./install.sh &> /dev/null
action 'Installed jwoll2 planform' [ $? -eq 0 ]
cd .. 

setenforce 0

mysql_buffer=$[ $(free -m | awk '/Mem/{print $2}') / 4 ]
sed -i "s#innodb_buffer_pool_size.*#innodb_buffer_pool_size = ${mysql_buffer}M#" /etc/my.cnf
sed -i 's/#!\/usr\/bin\/python/#!\/usr\/bin\/python2.6/g' /usr/bin/yum

service mysql start &> /dev/null
action 'service mysql start... success' [ $? -eq 0 ]


# get maintain scripts.
if [ ! -e bin ]
then
    mkdir bin
fi
cd bin 
svn co --non-interactive --username mfgamereadonly --password mfgamereadonly http://svn.ops.morefuntek.com/svn/code/jw2/scripts .  &> /dev/null
action 'Download script over.' [ $? -eq 0 ]

find . -maxdepth 1 -type f -exec chmod +x {} \;
\cp -r * /home/jwoll/bin/
chown -R jwoll:jwoll /home/jwoll

modif_conf(){
    sed -i "
    s/192.168.4.20/${IP}/
    s/jwoll_core_soft/${USER}/
    s/jwoll_2012/${PASSWD}/
    s/WP_JW2_Test_Manager/${DBNAME}/
    " /home/jwoll/bin/sv_conf.py
}

modif_conf

echo "Finished."
