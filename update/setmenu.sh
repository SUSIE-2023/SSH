#!/bin/bash
#!/bin/bash
clear
m="\033[0;1;36m"
y="\033[0;1;37m"
yy="\033[0;1;32m"
yl="\033[0;1;33m"
wh="\033[0m"
echo -e "$y                   การตั้งค่าระบบ$wh"
echo -e "$y-------------------------------------------------------------$wh"
echo -e "$yy 1$y.  เพิ่มหรือเปลี่ยนโฮสต์โดเมนย่อยสำหรับ VPS"
echo -e "$yy 2$y.  เปลี่ยนพอร์ตของบริการบางอย่าง"
echo -e "$yy 3$y.  การสำรองข้อมูลอัตโนมัติ VPS"
echo -e "$yy 4$y.  การสำรองข้อมูล VPS""
echo -e "$yy 5$y.  กู้คืนข้อมูล VPS"
echo -e "$yy 6$y.  เมนู Webmin"
echo -e "$yy 7$y.  จำกัดความเร็วแบนด์วิธเซิร์ฟเวอร์"
echo -e "$yy 8$y.  ตรวจสอบการใช้งาน VPS Ram"
echo -e "$yy 9$y.  รีบูต VPS"
echo -e "$yy 10$y. ทดสอบความเร็ว VPS"
echo -e "$yy 11$y. เริ่มบริการ VPN ใหม่"
echo -e "$yy 12$y. สคริปต์ข้อมูลติดตั้งอัตโนมัติ"
echo -e "$yy 13$y. ต่ออายุใบรับรอง XRAYS"
echo -e "$yy 14$y. ต่ออายุใบรับรอง NameServer(NS)"
echo -e "$yy 15$y. Install BBRPLUS 5.15.96 by UJX6N "
echo -e "$yy 16$y. Xray-core Changer "
echo -e "$yy 17$y. เปลี่ยนแบนเนอร์ SSH Websocket"
echo -e "$yy 18$y. คืนค่าพอร์ต SSH+SSL/TLS 443"
echo -e "$yy 19$y. เมนู SwapRAM "
echo -e "$yy 20$y. เมนู"
echo -e "$y-------------------------------------------------------------$wh"
echo -e ""
read -p "เลือกจากตัวเลือก [ 1 - 20 ] : " menu
echo -e ""
case $menu in
1)
addhost
;;
2)
changeport
;;
3)
autobackup
;;
4)
backup
;;
5)
restore
;;
6)
wbmn
;;
7)
limitspeed
;;
8)
ram
;;
9)
reboot
;;
10)
speedtest
;;
11)
restart
;;
12)
about
;;
13)
certv2ray && restart
;;
14)
install-sldns && restart
;;
15)
bbr2 && reboot
;;
16)
wget -q -O /usr/bin/xraychanger "https://raw.githubusercontent.com/NevermoreSSH/Xcore-custompath/main/xraychanger.sh" && chmod +x /usr/bin/xraychanger && xraychanger
;;
17)
nano /etc/issue.net
;;
18)
fssw
;;
19)
clear
wget -q -O /usr/bin/swapram "https://raw.githubusercontent.com/NevermoreSSH/swapram/main/swapram.sh" && chmod +x /usr/bin/swapram && swapram
;;
20)
clear
menu
;;
*)
clear
menu
;;
esac
