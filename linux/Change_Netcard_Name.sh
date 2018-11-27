#!/bin/bash
#This scripts used to change netcard name for centos7
NETNAME=ens192
NETDIR=/etc/sysconfig/network-scripts
NETCONF=$NETDIR/ifcfg-$NETNAME
NETCONF_NEW=$NETDIR/ifcfg-eth0
GRUBCONF=/etc/default/grub

Change_Netcard_Name(){
sed -i "s/$NETNAME/eth0/" $NETCONF #带变量的用双引号进行替换
mv $NETCONF $NETCONF_NEW

sed -r -i 's#(GRUB_CMDLINE_LINUX=).*#\1"crashkernel=auto rd.lvm.lv=cl_dc/root "net.ifnames=0 biosdevname=0" rd.lvm.lv=cl_dc/swap rhgb quiet"#' $GRUBCONF
grub2-mkconfig -o /boot/grub2/grub.cfg 

echo "It will reboot in 10 seconds"
sleep 10
reboot

}

Change_Netcard_Name

