#!/bin/bash
###
 # @Author: your name
 # @Date: 2021-02-13 14:29:24
 # @LastEditTime: 2021-02-14 12:12:04
 # @LastEditors: Please set LastEditors
 # @Description: In User Settings Edit
 # @FilePath: \undefinedc:\Users\frank\Desktop\docker_install.sh
### 




hostname="ceshi1"
workdir="/root/"
docker_root="/home/docker"





#读取当前系统的版本
release=$(cat /etc/redhat-release |grep -o -P '\d\.\d')
core=$(uname -a|awk '{print$3}'|grep -o "x86_64")


if [ -n "$core" ];then
    echo "检测到当前系统为64位系统"
    core_one=$(uname -a|awk '{print$3}'|grep "el7")
    core=$core_one
    if [ -n "$core" ];then
        echo "检测到当前系统为Centos7 64位操作系统"
    else
        echo "无法检测到内核版本，该脚本不支持接下来的操作，将退出。"
        exit
    fi
else
    core_one=$(uname -a|awk '{print$3}'|grep "x32")
    core=$core_one
    if [-n "$core" ];then
        echo "检测到当前系统为32位操作系统"
    else
        echo "无法检测到内核版本，该脚本不支持接下来的操作，将退出。"
        exit
    fi
fi


hostnamectl set-hostname $hostname
mkdir -p $workdir
mkdir -p $docker_root



function startOracle(){
	status="true"
	while [[ "$status" == "true" ]]
	do
		read -r -p "需要手动确定yum源是否安装正确.需要本地yum源以及docker yum源，是否启动? y已启动,n为退出脚本 [Y/n] " input

		case $input in
			[yY][eE][sS]|[yY])
				echo "Yes"
				status="false"
				;;

			[nN][oO]|[nN])
				echo "No"
				exit 1	       	
				;;

			*)
				echo "无效的输入.."
				;;
		esac
	done
}




#安装必要的依赖组件
yum install -y conntrack ntpdate ntp ipvsadm ipset jq iptables curl sysstat libseccomp wget vim net-tools git



#关停防火墙等等

systemctl stop firewalld && systemctl disable firewalld

yum -y install iptables-services && systemctl start iptables && systemctl enable iptables && iptables -F && service iptables save

setenforce 0 && sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config


#关闭虚拟内存
swapoff -a && sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab


cd $workdir

cat > kubernetes.conf <<EOF
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
net.ipv4.tcp_tw_recycle=0
vm.swappiness=0 # 禁止使用 swap 空间，只有当系统 OOM 时才允许使用它
vm.overcommit_memory=1 # 不检查物理内存是否够用
vm.panic_on_oom=0 # 开启 OOM
fs.inotify.max_user_instances=8192
fs.inotify.max_user_watches=1048576
fs.file-max=52706963
fs.nr_open=52706963
net.ipv6.conf.all.disable_ipv6=1
net.netfilter.nf_conntrack_max=2310720
EOF
cp kubernetes.conf /etc/sysctl.d/kubernetes.conf
sysctl -p /etc/sysctl.d/kubernetes.conf


#调整时区等等

# 设置系统时区为 中国/上海
timedatectl set-timezone Asia/Shanghai
# 将当前的 UTC 时间写入硬件时钟
timedatectl set-local-rtc 0
# 重启依赖于系统时间的服务
systemctl restart rsyslog
systemctl restart crond



mkdir /var/log/journal # 持久化保存日志的目录
mkdir /etc/systemd/journald.conf.d
cat > /etc/systemd/journald.conf.d/99-prophet.conf <<EOF
[Journal]
# 持久化保存到磁盘
Storage=persistent
# 压缩历史日志
Compress=yes
SyncIntervalSec=5m
RateLimitInterval=30s
RateLimitBurst=1000
# 最大占用空间 10G
SystemMaxUse=10G
# 单日志文件最大 200M
SystemMaxFileSize=200M
# 日志保存时间 2 周
MaxRetentionSec=2week
# 不将日志转发到 syslog
ForwardToSyslog=no
EOF

systemctl restart systemd-journald


yum -y install docker-ce docker-ce-cli containerd.io

mkdir /etc/docker

cat > /etc/docker/daemon.json <<EOF
{
    "data-root": "${docker_root}",
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    }
}
EOF

systemctl enable docker && systemctl start docker && systemctl status docker

 