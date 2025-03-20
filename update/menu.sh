#!/bin/bash
clear
m="\033[0;1;36m"
y="\033[0;1;37m"
yy="\033[0;1;32m"
yl="\033[0;1;33m"
wh="\033[0m"

## Foreground
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'

# Getting CPU Information
cores=$(awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo)
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*/} / ${corediilik:-1}))"
cpu_usage+="%"
load_cpu=$(printf '%-3s' "$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')")

# Domain & IPVPS
domain=$(cat /etc/xray/domain)
sldomain=$(cat /root/nsdomain)
IPVPS=$(curl -s ipinfo.io/ip)

# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"

# RAM Info
tram=$(free -m | awk 'NR==2 {print $2}')
uram=$(free -m | awk 'NR==2 {print $3}')

# Bandwidth Usage
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"

# FIX STUNNEL5 & XRAY Function
fix_stunnel_xray() {
    echo "กรุณากรอกข้อมูลสำหรับใบรับรอง SSL"

    read -p "Country Code (เช่น TH): " country
    read -p "State/Province (เช่น Bangkok): " state
    read -p "City (เช่น Bangkok): " city
    read -p "Organization (เช่น HDVPN): " org
    read -p "Organizational Unit (เช่น VPN Service): " unit
    read -p "Common Name (เช่น th1.hdvpn.win): " common_name
    read -p "Email Address: " email

    echo "กำลังสร้างใบรับรอง SSL..."
    openssl req -x509 -newkey rsa:2048 -keyout /etc/xray/xray.key -out /etc/xray/xray.crt -days 365 \
        -subj "/C=$country/ST=$state/L=$city/O=$org/OU=$unit/CN=$common_name/emailAddress=$email"

    echo "กำลังตั้งค่าสิทธิ์ให้กับไฟล์ใบรับรอง..."
    chmod 644 /etc/xray/xray.crt
    chmod 600 /etc/xray/xray.key

    echo "กำลังรีสตาร์ทบริการ stunnel5 และ xray..."
    systemctl restart stunnel5
    systemctl restart xray

    echo "กำลังตรวจสอบสถานะของบริการ stunnel5..."
    systemctl status stunnel5

    echo "กำลังตรวจสอบการฟังพอร์ตของ stunnel5..."
    netstat -tulnp | grep stunnel5

    echo "การติดตั้งและตั้งค่าเสร็จสมบูรณ์!"
    read -p "กด Enter เพื่อกลับสู่เมนูหลัก..."
    menu
}

# Display Menu
echo " "
echo -e "$y                        เมนูหลัก $wh"
echo -e "$y                สคริปต์ Mod โดย SUSIE $wh"
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "                ${WB} ♦️ ข้อมูลเซิฟเวอร์ ♦️ ${NC}             "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "  ${RB}♦️${NC} ${YB}OS       :  "$(hostnamectl | grep "ระบบปฏิบัติการ" | cut -d ' ' -f5-) ${NC}         
echo -e "  ${RB}♦️${NC} ${YB}KERNEL   :  $(uname -r) ${NC} "
echo -e "  ${RB}♦️${NC} ${YB}UPTIME   :  $uptime ${NC} "
echo -e "  ${RB}♦️${NC} ${YB}CPU      :  ${cores} core ($load_cpu)  ${NC} "
echo -e "  ${RB}♦️${NC} ${YB}RAM      :  $uram MB / $tram MB ${NC} "
echo -e "  ${RB}♦️${NC} ${YB}DOMAIN   :  $domain ${NC} "
echo -e "  ${RB}♦️${NC} ${YB}DNSTT    :  $sldomain ${NC} "
echo -e "  ${RB}♦️${NC} ${YB}IPVPS    :  $IPVPS ${NC} "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "                  ${WB} ♦️ แบนด์วิธรวม ♦️ ${NC}            "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "  ${RB}♦️${NC} ${YB}การใช้งานทุกวัน         : $ttoday ${NC}"
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "$YB 1$y.  เมนู SSH WEBSOCKET  $wh"
echo -e "$YB 2$y.  เมนู XRAY VMESS$wh"
echo -e "$YB 3$y.  เมนู XRAY VLESS$wh"
echo -e "$YB 4$y.  เมนู TROJAN XRAY$wh"
echo -e "$YB 5$y.  ข้อมูลทุกพอร์ต$wh"
echo -e "$YB 6$y.  ตรวจสอบบริการ VPN$wh"
echo -e "$YB 7$y.  เมนู (SlowDNS)$wh"
echo -e "$YB 8$y.  ตั้งค่า$wh"
echo -e "$YB 9$y.  ตรวจสอบซีพียูและแรม$wh"
echo -e "$YB 10$y. ตรวจสอบแบนด์วิดท์$wh"
echo -e "$YB 11$y. ตัวเปลี่ยน DNS$wh"
echo -e "$YB 12$y. ลบผู้ใช้ที่หมดอายุ$wh"
echo -e "$YB 13$y. อกก$wh"
echo -e "$YB 14$y. แก้ไข STUNNEL5 และ XRAY$wh"
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "${YB}"
read -p "เลือกจากตัวเลือก [ 1 - 14 ] : " menu
case $menu in
1)
clear
sshovpnmenu
;;
2)
clear
vmessmenu
;;
3)
clear
vlessmenu
;;
4)
clear
trmenu
;;
5)
clear
info
;;
6)
clear
running
;;
7)
clear
slowdnsmenu
;;
8)
clear
setmenu
;;
9)
clear
htop
;;
10)
clear
vnstat
;;
11)
clear
dns
;;
12)
clear
delexp && xp && restart
;;
13)
clear
exit
;;
14)
clear
fix_stunnel_xray
;;
*)
clear
menu
;;
esac